require 'date'

class Student
  attr_reader :surname, :name, :date_of_birth
  @@students = []  
  
  def initialize(surname, name, date_of_birth)
    @surname = surname
    @name = name
    
    if date_of_birth > Date.today
      raise ArgumentError, 'Date of birth must be in the past'
    end

    @date_of_birth = date_of_birth
    add_student(self)  
  end

  def calculate_age
    today = Date.today
    age = today.year - @date_of_birth.year
    age -= 1 if today < @date_of_birth.next_year(age)  
    age
  end

  def self.add_student(new_student)
    unless @@students.any? { |student| student.eql?(new_student) }
      @@students << new_student
    end
  end

  def add_student(student)
    self.class.add_student(student)
  end

  def self.remove_student(student)
    @@students.delete(student)
  end

  def self.get_students_by_age(age)
    @@students.select { |student| student.calculate_age == age }
  end

  def self.get_students_by_name(name)
    @@students.select { |student| student.name == name }
  end

  def eql?(other)
    other.is_a?(Student) && @surname == other.surname && @name == other.name && @date_of_birth == other.date_of_birth
  end

  def to_s
    "#{@surname} #{@name}, born on #{@date_of_birth}"
  end

  def self.students
    @@students
  end
end

students_data = [
  { surname: "Maslov", name: "Danylo", date_of_birth: Date.new(2005, 9, 24) },
  { surname: "Ivanov", name: "Timur", date_of_birth: Date.new(2004, 5, 15) },
  { surname: "Krasin", name: "Misha", date_of_birth: Date.new(2004, 3, 2) },
  { surname: "Kulikov", name: "Vladimir", date_of_birth: Date.new(2005, 1, 3) }
]

students_data.each do |student_data|
  Student.new(student_data[:surname], student_data[:name], student_data[:date_of_birth])
end

puts "\nList of unique students:"
Student.students.each { |student| puts student }