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

    def initialize(info)
        @id = info['id']
        @title = info['title']
        @body = info['body']
        @author_id = info['author_id']
    end

end