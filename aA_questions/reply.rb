require_relative 'connection'
require_relative 'user'
require_relative 'question'
require_relative 'question_like'
require_relative 'question_follow'

class Reply

    attr_accessor :id, :user_id, :question_id, :parent_id, :body
  
    def self.all
        data = QuestionDBConnection.instance.execute("SELECT * FROM replies")
        data.map { |datum| Reply.new(datum) }
    end
  
    def self.find_by_id(r_id)
        data = QuestionDBConnection.instance.execute(<<-SQL, r_id: r_id)
          select * from replies
          where id = :r_id
        SQL
        data.map { |datum| Reply.new(datum) }
    end
  
    def self.find_by_user_id(u_id)
        data = QuestionDBConnection.instance.execute(<<-SQL, u_id: u_id)
          select * from replies
          where user_id = :u_id
        SQL
        data.map { |datum| Reply.new(datum) }
    end
  
    def self.find_by_question_id(q_id)
        data = QuestionDBConnection.instance.execute(<<-SQL, q_id: q_id)
          select * from replies
          where question_id = :q_id
        SQL
        data.map { |datum| Reply.new(datum) }
    end
  
    def initialize(info)
        @id = info['id']
        @user_id = info['user_id']
        @question_id = info['question_id']
        @parent_id = info['parent_id']
        @body = info['body']
    end
    
    def author
      User.find_by_id(user_id)[0]
    end
    
    def question
      Question.find_by_id(question_id)[0]
    end
  
    def parent_reply
      Reply.find_by_id(parent_id)[0]
    end
  
    def child_replies
      data = QuestionDBConnection.instance.execute(<<-SQL, id: self.id )
        select * from replies
        where parent_id = :id
      SQL
      data.map { |datum| Reply.new(datum) }[0]
    end
  
  end