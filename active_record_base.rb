require 'active_support/inflector'

class ActiveRecordBase

  def self.method_missing(m, *args, &block)
    where = m.to_s[8..-1]
    if args.count == 1
      query_result = QuestionsDatabase.execute(<<-SQL, args[0])[0]
        SELECT
          *
        FROM
          #{name.tableize}
        WHERE
          #{where} = ?
      SQL
    else
      lookups = where.split('_and_')
      lookups = lookups.map { |column| "#{column} = ?" }.join(" AND ")
      query_result = QuestionsDatabase.execute(<<-SQL, *args)[0]
        SELECT
          *
        FROM
          #{name.tableize}
        WHERE
          #{lookups}
      SQL
    end
    query_result.map { |options| self.new(options) }
  end

  def self.find_by(id)
    self.new(QuestionsDatabase.execute(<<-SQL, id)[0])
      SELECT
        *
      FROM
        #{name.tableize}
      WHERE
        id = ?
    SQL
  end


  def save
    columns = instance_variables.map { |symbol| symbol.to_s[1.. -1] }
    values = instance_variables.map { |var| instance_variable_get(var) }

    if @id
      set_line = columns[0..-2].map {|col| "#{col} = ?"}.join(', ')

      QuestionsDatabase.execute(<<-SQL, *values)
        UPDATE
          #{self.class.name.tableize}
        SET
          #{set_line}
        WHERE
          id = ?
      SQL
    else
      value_line = values.map {|val| "?"}.join(', ')
      value_line = "(" + value_line + ")"
      csv_cols = "(" + columns.join(', ') + ")"

      QuestionsDatabase.execute(<<-SQL, *values)
        INSERT INTO
          #{self.class.name.tableize} #{csv_cols}
        VALUES
          #{value_line};
      SQL
    end
  end
end
