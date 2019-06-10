require_relative 'connection'
require_relative 'user'
require_relative 'question'
require_relative 'question_like'
require_relative 'reply'

class QuestionFollow

    attr_accessor :id, :user_id, :question_id
  
    def self.all
        data = QuestionDBConnection.instance.execsute("SELECT * FROM question_follows")
        data.map { |datum| QuestionFollow.new(datum) }
    end
  
    def self.find_by_id(qf_id)
        data = QuestionDBConnection.instance.execute(<<-SQL, qf_id: qf_id)
          select * from question_follows
          where id = :qf_id
        SQL
        data.map { |datum| QuestionFollow.new(datum) }
    end
  
    def self.followers_for_question_id(question_id)
      data = QuestionDBConnection.instance.execute(<<-SQL, q_id: question_id)
        select users.id, fname, lname from users
        join question_follows on question_follows.user_id = users.id
        where question_follows.question_id = :q_id
      SQL
      data.map { |datum| User.new(datum) }
    end
  
    def self.followed_questions_for_user_id(user_id)
      data = QuestionDBConnection.instance.execute(<<-SQL, u_id: user_id)
        select questions.id, questions.title, questions.body, questions.author_id from questions
        join question_follows on question_follows.question_id = questions.id
        where question_follows.user_id = :u_id
      SQL
      data.map { |datum| Question.new(datum) }
    end
  
    def self.most_followed_questions(n)
      data = QuestionDBConnection.instance.execute(<<-SQL, n: n)
        select questions.id, questions.title, questions.body, questions.author_id from questions
        join question_follows on question_follows.question_id = questions.id
        group by question_id
        order by count(question_follows.user_id) desc
        limit :n
      SQL
      data.map { |datum| Question.new(datum) }
    end
  
    def initialize(info)
        @id = info['id']
        @user_id = info['user_id']
        @question_id = info['question_id']
    end
  
  end