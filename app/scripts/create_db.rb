# frozen_string_literal: true

# HACK: Normally, I would probably do this instead with migrations or such, but this is fine

require 'sequel'

DB_PATH = 'db.sqlite'
DB = Sequel.sqlite(DB_PATH)

DB.create_table! :users do
  primary_key :id
  String :username, null: false, unique: true
  String :display_name
  String :bio
  TrueClass :anonymous, null: false, default: false
  TrueClass :champion, null: false, default: false
end

DB.create_table! :comment do
  primary_key :id
  String :text
  foreign_key :user_id, :users
  DateTime :created_at
  DateTime :modified_at
end

DB.create_table! :comment_events do
  primary_key :id
  foreign_key :comment_id, :comments
  foreign_key :user_id, :users
  String :event_type
  String :metadata
  DateTime :created_at
end
