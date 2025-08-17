# frozen_string_literal: true

require 'sequel'
require_relative 'db'
require 'dotiw'

# Represents a user
class User < Sequel::Model
  one_to_many :posts, graph_join_type: :inner
  one_to_many :post_events

  def self.find_username(username)
    where(username: username).first
  end
end

# Represents a single comment
class Post < Sequel::Model
  many_to_one :user, graph_join_type: :inner
  one_to_many :post_events
  one_to_many :post_vouchers

  include DOTIW::Methods

  # This needs to run with all
  def self.anonymous
    Post.eager_graph(:user).where(anonymous: true).all
  end

  def self.not_anonymous
    Post.eager_graph(:user).where(anonymous: false).all
  end

  def display_timestamp
    time_ago_in_words(created_at, only: %i[minutes hours days], highest_measure_only: true, compact: true)
  end

  def anonymous?
    user.anonymous
  end

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

  # Types
  POST_CREATED = 1
  POST_VOUCHED = 2
  POST_UNVOUCHED = 3
  POST_EDITED = 4

  def display_type
    case event_type
    when POST_CREATED
      'Created'
    when POST_VOUCHED
      'Vouched'
    when POST_UNVOUCHED
      'Unvouched'
    when POST_EDITED
      'Edited'
    end
  end
end

PostEvent.plugin :enum
PostEvent.enum :event_type, post_created: PostEvent::POST_CREATED, post_vouched: PostEvent::POST_VOUCHED,
                            post_unvouched: PostEvent::POST_UNVOUCHED, post_edited: PostEvent::POST_EDITED

class PostVoucher < Sequel::Model
  many_to_one :post
  many_to_one :user
end
