# frozen_string_literal: true

require 'sequel'
require_relative 'db'

# Represents a user
class User < Sequel::Model
  one_to_many :posts
  one_to_many :post_events

  def self.find_username(username)
    where(username: username).first
  end
end

# Represents a single comment
class Post < Sequel::Model
  many_to_one :user
  one_to_many :post_events
  one_to_many :post_vouchers

  def vouched?
    post_vouchers.any?
  end

  def vouched_by?(user)
    post_vouchers.any? { |pv| pv.user_id == user.id }
  end
end

# Represents a Posting Event
class PostEvent < Sequel::Model
  many_to_one :post
  many_to_one :user
end

PostEvent.plugin :enum
PostEvent.enum :event_type, post_created: 1, post_vouched: 2, post_unvouched: 3, post_edited: 4

class PostVoucher < Sequel::Model
  many_to_one :post
  many_to_one :user
end
