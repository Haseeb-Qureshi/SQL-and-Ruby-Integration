
class Follow < ActiveRecordBase
  attr_accessor :question, :user
  def initialize(options)
    @question = options['question_id']
    @user = options['user_id']
  end

  def self.most_followed_questions(n)
    most_followed = QuestionsDatabase.execute(<<-SQL, n)
      SELECT
        (*)
      FROM
        question_follows
      GROUP BY
        question_id
      ORDER BY
        COUNT(*) DESC
      LIMIT
        ?
    SQL

    array_of_questions(most_followed)
  end

  def array_of_questions(arr)
    arr.inject([]) do |all, options|
      all << Question.new(options)
    end
  end

  def followers_for_question_id(question_id)
    #return all users who are following this question
    followers = QuestionsDatabase.execute(<<-SQL, question_id)
      SELECT
        id
      FROM
        users
      JOIN
        question_follows ON user_id = users.id
      WHERE
        question_follows.question_id = ?
    SQL

    followers.inject([]) do |all, follower_id|
      all << User.find_by(follower_id)
    end
  end

  def followed_questions_for_user_id(user_id)
    questions = QuestionsDatabase.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.user_id
      FROM
        question_follows
      INNER JOIN
        questions on questions.id = question_id
      WHERE
        question_follows.user_id = ?
    SQL

    array_of_questions(questions)
  end

end
