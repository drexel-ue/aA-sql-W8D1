require_relative 'connection'
require_relative 'question'
require_relative 'question_like'
require_relative 'reply'
require_relative 'question_follow'

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
        data.map { |datum| User.new(datum) }[0]
    end
  
    def self.find_by_name(fname, lname)
      data = QuestionDBConnection.instance.execute(<<-SQL, fname: fname, lname: lname)
        select * from users
        where fname = :fname and lname = :lname
      SQL
      data.map { |datum| User.new(datum) }[0]
    end
  
    def initialize(info)
        @id = info['id']
        @fname = info['fname']
        @lname = info['lname']
    end
  
    def authored_questions
       Question.find_by_author_id(self.id)
    end
  
    def authored_replies
       Reply.find_by_user_id(self.id)
    end
  
    def followed_questions
      QuestionFollow.followed_questions_for_user_id(self.id)
    end
  
    def liked_questions 
       QuestionLike.liked_questions_for_user_id(self.id)
    end
  
    def average_karma
      data = QuestionDBConnection.instance.execute(<<-SQL, u_id: self.id)
        select count(question_likes.id ) / count(distinct questions.id ) as avg
        from questions
        join users on users.id = questions.author_id 
        LEFT OUTER join question_likes on questions.id = question_likes.question_id
        where questions.author_id = :u_id
        group by users.id
      SQL
    end
  
  end