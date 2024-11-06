require "minitest/autorun"
require "minitest/reporters"
require "date"
require_relative "Task1"

Minitest::Reporters.use! [
  Minitest::Reporters::SpecReporter.new,
  Minitest::Reporters::HtmlReporter.new(
    reports_dir: "test_reports/html",
    output_filename: "UnitTests.html",
  ),
]

class StudentTest < Minitest::Test
  def setup
    @student1 = Student.new("Maslov", "Danylo", Date.new(2005, 9, 24))
    @student2 = Student.new("Ivanov", "Timur", Date.new(2004, 5, 15))
    @student3 = Student.new("Krasin", "Misha", Date.new(2004, 3, 2))
    @student4 = Student.new("Kulikov", "Vladimir", Date.new(2005, 1, 3))

    [@student1, @student2, @student3, @student4].each { |student| Student.add_student(student) }
  end

  def teardown
    Student.students.clear
  end

  def test_initialize
    msg = "Attributes should be correct and accessible for reading"
    assert_equal "Danylo", @student1.name, msg
    assert_equal "Maslov", @student1.surname, msg
    assert_equal Date.new(2005, 9, 24), @student1.date_of_birth, msg
  end

  def test_future_birth_date
    msg = "Creating a student with future birth date should raise ArgumentError"
    Date.stub :today, Date.new(2024, 11, 5) do
      assert_raises(ArgumentError, msg) do
        Student.new("Test", "Student", Date.new(2025, 1, 1))
      end
    end
  end

  def test_calculate_age
    msg = "Student.calculate_age should return correct age"
    Date.stub :today, Date.new(2024, 11, 5) do
      assert_equal 19, @student1.calculate_age, msg
      assert_equal 20, @student2.calculate_age, msg
    end
  end

  def test_students_equal
    msg = "Students with same attributes should be considered equal"
    student1_copy = Student.new("Maslov", "Danylo", Date.new(2005, 9, 24))
    assert @student1.eql?(student1_copy), msg
  end

  def test_add_new_student
    msg = "Students array should include a new student"
    new_student = Student.new("Petrov", "Alex", Date.new(2006, 6, 15))
    Student.add_student(new_student)
    assert_includes Student.students, new_student, msg
  end

  def test_add_student_copy
    msg = "Adding an existing student copy should not duplicate entry"
    initial_count = Student.students.size
    Student.add_student(@student1)
    assert_equal initial_count, Student.students.size, msg
  end

  def test_remove_student
    msg = "Student should not be in the students array after removal"
    Student.remove_student(@student1)
    refute_includes Student.students, @student1, msg
  end

  def test_get_students_by_age
    msg = "Student.get_students_by_age should return students with specified age"
    Date.stub :today, Date.new(2024, 11, 5) do
      students_aged_19 = Student.get_students_by_age(19)
      assert_equal [@student1, @student4], students_aged_19, msg
    end
  end

  def test_get_students_by_name
    msg = "Student.get_students_by_name should return students with specified name"
    students_named_danylo = Student.get_students_by_name("Danylo")
    assert_equal [@student1], students_named_danylo, msg
  end
end
