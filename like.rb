class Like
  attr_accessor :question, :user

  def self.likers_for_question_id(question_id)
    likers = QuestionsDatabase.execute(<<-SQL, question_id)
      SELECT
        user_id
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL

    likers.inject([]) do |all, liker_id|
      all << User.find_by(liker_id)
    end
  end

  def self.num_likes_for_question_id(question_id)
    QuestionsDatabase.execute(<<-SQL, question_id)
      SELECT
        COUNT(*)
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL
  end

  def self.liked_questions_for_user_id(user_id)
    QuestionsDatabase.execute(<<-SQL, user_id)
      SELECT
        COUNT(*)
      FROM
        question_likes
      WHERE
        user_id = ?
    SQL
  end

  def self.most_liked_questions(n)
    questions = QuestionsDatabase.execute(<<-SQL, n)
      SELECT
        question_id
      FROM
        question_likes
      GROUP BY
        question_id
      ORDER BY
        COUNT(*) DESC
      LIMIT
        ?
    SQL

    questions.inject([]) do |all, most_liked|
      all << Question.find_by(most_liked)
    end
  end

  def initialize(options)
    @question = options['question_id']
    @user = options['user_id']
  end
end
