# frozen_string_literal: true

# HACK: Normally, I would probably do this instead with migrations or such, but this is fine
require_relative '../db'

class Database
  def create_tables
    @conn.create_table! :users do
      primary_key :id
      String :username, null: false, unique: true
      String :display_name
      String :bio
      TrueClass :anonymous, null: false, default: false
      TrueClass :champion, null: false, default: false
    end

    @conn.create_table! :posts do
      primary_key :id
      String :text
      foreign_key :user_id, :users
      DateTime :created_at
      DateTime :updated_at
    end

    @conn.create_table! :post_events do
      primary_key :id
      foreign_key :post_id, :posts
      foreign_key :user_id, :users
      Integer :event_type, null: false
      String :metadata
      DateTime :created_at
    end

    # A useful cached table
    @conn.create_table! :post_vouchers do
      primary_key :id
      foreign_key :post_id, :posts
      foreign_key :user_id, :users
    end
  end
end
