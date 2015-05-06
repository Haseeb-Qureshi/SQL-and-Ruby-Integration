require 'sqlite3'
require 'singleton'
require 'active_support/inflector'
require_relative 'user'
require_relative 'reply'
require_relative 'question'
require_relative 'like'
require_relative 'follow'
require_relative 'active_record_base'


class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end

  def self.execute(*args, &blk)
    instance.execute(*args, &blk)
  end
end
