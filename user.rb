require_relative 'active_record_base'
require 'active_support/inflector'
class User < ActiveRecordBase
  attr_accessor :fname, :lname
  attr_reader :id
  def initialize(options)
    @fname = options['fname']
    @lname = options['lname']
    @id = options['id'] if caller[0].include?("active_record_base")
  end

  def self.find_by_name(fname, lname)
    User.new(QuestionsDatabase.execute(<<-SQL, fname, lname)[0])
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
  end

  def valid_id?(id)
    validated = QuestionsDatabase.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return false if validated.empty?

    @fname == validated[0]['fname'] && @lname == validated[0]['lname']
  end

  def authored_questions
    Question.find_by_user_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def average_karma
    QuestionsDatabase.execute(<<-SQL, @id)
      SELECT
        COUNT(DISTINCT question_likes.id) /
        CAST(COUNT(DISTINCT questions.id) AS FLOAT) AS avg_karma
      FROM
        questions
      LEFT OUTER JOIN
        question_likes
      ON
        questions.id = question_likes.question_id
      GROUP BY
        questions.user_id
      HAVING
        questions.user_id = ?
    SQL
  end

  def followed_questions
    Follow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    Like.liked_questions_for_user_id(@id)
  end

  # def save
  #   if @id  #Update
  #     QuestionsDatabase.execute(<<-SQL, @fname, @lname, @id)
  #       UPDATE
  #         '#{self.class.name.tableize}'
  #       SET
  #         fname = ?, lname = ?
  #       WHERE
  #         id = ?;
  #     SQL
  #   else  #insert
  #     QuestionsDatabase.execute(<<-SQL, fname, lname)
  #       INSERT INTO
  #         '#{self.class.name.tableize}' (fname, lname)
  #       VALUES
  #         (?, ?);
  #     SQL
  #   end
  # end
end
