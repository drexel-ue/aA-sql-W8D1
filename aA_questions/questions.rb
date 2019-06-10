require 'sqlite3'
require 'singleton'

class QuestionDBConnection < SQLite3::Database

  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end

end

class Question

    attr_accessor :id, :body, :title, :author_id

    def self.all
        data = QuestionDBConnection.instance.execute("SELECT * FROM questions")
        data.map { |datum| Question.new(datum) }
    end

    def self.find_by_id(qid)
        data = QuestionDBConnection.instance.execute(<<-SQL, qid: qid)
          select * from questions
          where id = :qid
        SQL
        data.map { |datum| Question.new(datum) }
    end

    def initialize(info)
        @id = info['id']
        @title = info['title']
        @body = info['body']
        @author_id = info['author_id']
    end

end

class User

  attr_accessor :id, :fname, :lname

  def self.all
      data = QuestionDBConnection.instance.execute("SELECT * FROM users")
      data.map { |datum| User.new(datum) }
  end

  def self.find_by_id(uid)
      data = QuestionDBConnection.instance.execute(<<-SQL, uid: uid)
        select * from users
        where id = :uid
      SQL
      data.map { |datum| User.new(datum) }
  end

  def self.find_by_name(fname, lname)
    data = QuestionDBConnection.instance.execute(<<-SQL, fname: fname, lname: lname)
      select * from users
      where fname = :fname and lname = :lname
    SQL
    data.map { |datum| User.new(datum) }
end

  def initialize(info)
      @id = info['id']
      @fname = info['fname']
      @lname = info['lname']
  end

end


