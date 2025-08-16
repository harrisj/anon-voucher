# frozen_string_literal: true

require 'sequel'

# Represents a user
class User < Sequel::Model
  one_to_many :comments
  one_to_many :comment_events
end

# Represents a single comment
class Comment < Sequel::Model
  many_to_one :user
  one_to_many :comment_events
end

# Represents a Comment Event
class CommentEvent < Sequel::Model
  many_to_one :comment
  many_to_one :user
end
