require "minitest/autorun"
require "minitest/spec"
require "minitest/reporters"
require "date"
require_relative "Task1"  

Minitest::Reporters.use! [
  Minitest::Reporters::SpecReporter.new,
  Minitest::Reporters::HtmlReporter.new(
    reports_dir: "test_reports/html",
    output_filename: "SpecTests.html",
  ),
]

describe Student do
  before do
    Student.students.clear
  end

  let(:student) { Student.new("Maslov", "Danylo", Date.new(2005, 9, 24)) }
  let(:student_copy) { Student.new("Maslov", "Danylo", Date.new(2005, 9, 24)) }

  describe "attributes" do
    it "should correctly initialize name, surname, and date_of_birth" do
      expect(student.name).must_equal "Danylo"
      expect(student.surname).must_equal "Maslov"
      expect(student.date_of_birth).must_equal Date.new(2005, 9, 24)
    end

    it "should not allow a future date of birth" do
      expect {
        Date.stub :today, Date.new(2024, 11, 5) do
          Student.new("Test", "Future", Date.new(2025, 1, 1))
        end
      }.must_raise ArgumentError
    end
  end

  describe "#calculate_age" do
    it "should return the correct age" do
      Date.stub :today, Date.new(2024, 11, 5) do
        expect(student.calculate_age).must_equal 19
      end
    end
  end

  describe ".add_student" do
    it "should add a new student to the students array" do
      Student.add_student(student)
      expect(Student.students).must_include student
    end

    it "should not add a duplicate student" do
      Student.add_student(student)
      initial_count = Student.students.size
      Student.add_student(student_copy)
      expect(Student.students.size).must_equal initial_count
    end
  end

  describe ".remove_student" do
    it "should remove a student from the students array" do
      Student.add_student(student)
      Student.remove_student(student)
      expect(Student.students).wont_include student
    end
  end

  describe ".get_students_by_age" do
    let(:student2) { Student.new("Ivanov", "Timur", Date.new(2004, 5, 15)) }
    let(:student3) { Student.new("Krasin", "Misha", Date.new(2004, 3, 2)) }

    it "should return only students with the specified age" do
      [student, student2, student3].each { |s| Student.add_student(s) }
      Date.stub :today, Date.new(2024, 11, 5) do
        students_aged_19 = Student.get_students_by_age(19)
        expect(students_aged_19).must_equal [student]
      end
    end
  end

  describe ".get_students_by_name" do
    let(:student2) { Student.new("Ivanov", "Danylo", Date.new(2005, 1, 3)) }
    let(:student3) { Student.new("Kulikov", "Timur", Date.new(2004, 3, 2)) }

    it "should return only students with the specified name" do
      [student, student2, student3].each { |s| Student.add_student(s) }
      students_named_danylo = Student.get_students_by_name("Danylo")
      expect(students_named_danylo).must_equal [student, student2]
    end
  end
end
