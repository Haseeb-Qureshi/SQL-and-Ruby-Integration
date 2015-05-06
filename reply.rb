class Reply < ActiveRecordBase
  attr_accessor :question, :user, :reply, :body
  def initialize(options)
    @question_id = options['question_id']
    @reply_id = options['reply_id']
    @user_id = options['user_id']
    @body = options['body']
    @id = options['id']
  end
  #
  # def self.find_by_question_id(question_id)
  #   replies = Reply.new(QuestionsDatabase.execute(<<-SQL, question_id) )
  #     SELECT
  #       *
  #     FROM
  #       replies
  #     WHERE
  #       question_id = ?
  #   SQL
  #   replies.inject([]) do |all, reply|
  #     all << Reply.new(reply)
  #   end
  # end

  def author
    User.find_by(@user_id)
  end

  def parent_reply
    Reply.find_by(@reply_id)
  end

  def child_replies
    Reply.new(QuestionsDatabase.execute(<<-SQL, @id)[0] )
      SELECT
        *
      FROM
        replies
      WHERE
        reply_id = ?
    SQL
  end

end
