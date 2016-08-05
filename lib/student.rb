require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.create_table
    sql = " CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER);"
    DB[:conn].execute(sql)
  end

  def save
    sql = " INSERT INTO students (name, grade) VALUES (?, ?);"
    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.all
    sql= " SELECT * FROM students;"
    DB[:conn].execute(sql).collect do |each_row|
      self.new_from_db(each_row)
    end
  end

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name =  row[1]
    student.grade = row[2]
    student
  end

  def self.find_by_name(name)
    # binding.pry
    sql = " SELECT * FROM students  WHERE name = ? LIMIT 1;"
    row = DB[:conn].execute(sql, name).first
    Student.new_from_db(row)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12;"
    DB[:conn].execute(sql).collect do |each_row|
      self.new_from_db(each_row)
      end
  end

  def self.count_all_students_in_grade_9
    sql = " SELECT COUNT (*) FROM students WHERE grade = 9;"
    DB[:conn].execute(sql).collect do |each_row|
      self.new_from_db(each_row)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10
      ORDER BY students.id ASC LIMIT 1
      SQL
    row = DB[:conn].execute(sql).first
    self.new_from_db(row)
  end

  def self.first_x_students_in_grade_10(x)
   sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?;"
   DB[:conn].execute(sql, x)
 end

 def self.all_students_in_grade_X(x)
  sql = "SELECT name FROM students WHERE grade = ?;"
   DB[:conn].execute(sql, x)
end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end


end
