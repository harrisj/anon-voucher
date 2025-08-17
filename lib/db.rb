# frozen_string_literal: true

require 'sequel'

class Database
  DB_PATH = 'db.sqlite'

  def initialize
    @conn = Sequel.sqlite(DB_PATH)
  end
end

DB = Database.new
