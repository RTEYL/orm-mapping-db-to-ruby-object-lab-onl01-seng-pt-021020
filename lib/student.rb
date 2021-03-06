class Student
  attr_accessor :name, :grade, :id

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students;
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    self.all.find{ |student| student.name == name}
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?);
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students;"
    DB[:conn].execute(sql)
  end
  def self.all_students_in_grade_9
    self.all.find_all { |student| student.grade == '9' }
  end
  def self.students_below_12th_grade
    self.all.find_all { |student| student.grade < '12' }
  end
  def self.first_X_students_in_grade_10(x)
    x.times.map { self.all.find { |student| student.grade == '10' } }
  end
  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1).first
  end
  def self.all_students_in_grade_X(x)
    self.all.find_all { |student| student.grade == "#{x}" }
  end
end
