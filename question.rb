class Question < ActiveRecordBase
  attr_accessor :title, :body, :user, :id
  def initialize(options)
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
    @id = options['id']
  end

  def self.find_by_user_id(user_id)
    questions = Question.new(QuestionsDatabase.execute(<<-SQL, user_id))
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL
    questions.inject([]) do |all, question|
      all << Question.new(question)
    end
  end

  def self.most_followed(n)
    Follow.most_followed_questions(n)
  end

  def self.most_liked(n)
    Like.most_liked_questions(n)
  end

  def author
    User.find_by(@user_id)
  end

  def followers
    Follow.followers_for_question_id(@id)
  end

  def replies
    Reply.find_by_id(@user_id)
  end

  def likers
    Like.likers_for_question_id(@id)
  end

  def num_likes
    Like.num_likes_for_question_id(@id)
  end
end
