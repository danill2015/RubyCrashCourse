require 'selenium-webdriver'
require 'capybara/rspec'
require_relative 'spec_helper'

RSpec.describe 'Login Tests' do

  before(:each) do
    @item_amount = 0
    @driver = Capybara::Session.new(:selenium)
    @driver.visit @url
  end

  context "Login with username and password" do
    usernames = ['standard_user', 'locked_out_user', 'error_user']
    correct_password = 'secret_sauce'
    incorrect_password = '12312'
    usernames.each do |username|
      if username == 'error_user'
        it "should be able to login with the #{username} and password" do
          log_in_to_account(username, incorrect_password)
        end
      elsif username == 'locked_out_user'
        it "should be able to login with the #{username} and password" do
          log_in_to_account(username, correct_password)
        end
      else
        it "Log in to your current account" do
          log_in_to_account(username, correct_password)
        end

        it "add item to cart" do
          log_in_to_account(username, correct_password)

          add_backpack_button_data_test = '[data-test="add-to-cart-sauce-labs-backpack"]'
          add_product_to_cart(add_backpack_button_data_test)

          add_fleece_jacket_button_data_test = '[data-test="add-to-cart-sauce-labs-fleece-jacket"]'
          add_product_to_cart(add_fleece_jacket_button_data_test)
        end

      end
    end
  end

  def log_in_to_account(user_name, password)
    @driver.fill_in 'user-name', visible: true, with: user_name
    @driver.fill_in 'password', visible: true, with: password
    @driver.click_button('Login')

    if user_name == 'error_user'
      user_with_some_error("Epic sadface: Username and password do not match any user in this service")
    elsif user_name == 'locked_out_user'
      user_with_some_error("Epic sadface: Sorry, this user has been locked out.")
    else
      expect(@driver).to have_selector('[data-test="title"]', text: "Products")
    end
  end

  def add_product_to_cart(data_test)
    add_button = @driver.find(data_test)
    add_button.click

    if !add_button.nil?
      @item_amount +=1
      expect(@driver).to have_selector('[data-test="shopping-cart-badge"]', text: @item_amount)
    end
  end

  def user_with_some_error(error_text)
    expect(@driver).to have_selector('[data-test="error"]', text: error_text)
  end
end