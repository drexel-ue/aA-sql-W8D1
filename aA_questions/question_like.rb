require_relative 'connection'
require_relative 'user'
require_relative 'question'
require_relative 'reply'
require_relative 'question_follow'

class QuestionLike

  attr_accessor :id, :user_id, :question_id

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM question_likes")
    data.map { |datum| QuestionLike.new(datum) }
  end

  def self.find_by_id(ql_id)
    data = QuestionDBConnection.instance.execute(<<-SQL, ql_id: ql_id)
      select * from question_likes
      where id = :ql_id
    SQL
    data.map { |datum| QuestionLike.new(datum) }
  end

  def self.likers_for_question_id(question_id)
    data = QuestionDBConnection.instance.execute(<<-SQL, q_id: question_id)
      select users.id, users.fname, users.lname from users
      join question_likes on question_likes.user_id = users.id
      where question_likes.question_id = :q_id
    SQL
    data.map { |datum| User.new(datum) }
  end

  def self.num_likes_for_question_id(question_id)
    n = QuestionDBConnection.instance.execute(<<-SQL, q_id: question_id)
      select count(*) as count from users
      join question_likes on question_likes.user_id = users.id
      where question_likes.question_id = :q_id
    SQL
    n[0]['count']
  end

  def self.liked_questions_for_user_id(user_id)
    data = QuestionDBConnection.instance.execute(<<-SQL, u_id: user_id)
      select questions.id, questions.title, questions.body, questions.author_id from questions
      join question_likes on question_likes.question_id = questions.id
      where question_likes.user_id = :u_id
    SQL
    data.map { |datum| Question.new(datum) }
  end

  def self.most_liked_questions(n)
    data = QuestionDBConnection.instance.execute(<<-SQL, n: n)
      select questions.id, questions.title, questions.body, questions.author_id from questions
      join question_likes on question_likes.question_id = questions.id
      group by question_id
      order by count(question_likes.user_id) desc
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

