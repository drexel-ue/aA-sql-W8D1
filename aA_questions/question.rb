require_relative 'connection'
require_relative 'user'
require_relative 'question_like'
require_relative 'reply'
require_relative 'question_follow'

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
        data.map { |datum| Question.new(datum) }[0]
    end

    def self.find_by_author_id(a_id)
        data = QuestionDBConnection.instance.execute(<<-SQL, a_id: a_id)
          select * from questions
          where author_id = :a_id
        SQL
        data.map { |datum| Question.new(datum) }
    end

    def self.most_followed(n)
       QuestionFollow.most_followed_questions(n)
    end

    def self.most_liked(n)
      QuestionLike.most_liked_questions(n)
    end
    
    def initialize(info)
        @id = info['id']
        @title = info['title']
        @body = info['body']
        @author_id = info['author_id']
    end

    def author
      User.find_by_id(self.author_id)[0]
    end

    def replies
      Reply.find_by_question_id( self.id )[0]
    end

    def followers  
      QuestionFollow.followers_for_question_id(self.id)
    end
     
    def likers
      QuestionLike.likers_for_question_id(self.id)
    end

    def num_likes
      QuestionLike.num_likes_for_question_id(self.id)
    end

    def save
      if self.id
        data = QuestionDBConnection.instance.execute(<<-SQL, id: self.id, title: self.title, body: self.body, author_id: self.author_id)
          update questions
          set title = :title, body = :body
          where id = :id and author_id = :author_id
        SQL
      else
        data = QuestionDBConnection.instance.execute(<<-SQL, id: self.id, title: self.title, body: self.body, author_id: self.author_id)
          insert into questions
          (id, title, body, author_id)
          values
          (:id, :title, :body, :author_id)
        SQL
        self.id = QuestionDBConnection.instance.last_insert_row_id
      end
    end

end