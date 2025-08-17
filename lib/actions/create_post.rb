require 'sinatra'
require_relative '../models'

module Actions
  class CreatePost
    def initialize(username:, text:, timestamp: nil)
      @username = username
      @text = text
      @timestamp = timestamp || Time.now
    end

    def run
      user = User.find_username(@username)
      raise NotFound, 'User not found' if user.nil?

      raise BadRequest, 'Post text must not be blank' if @text.nil? || @text.empty?

      post = Post.create({ text: @text,
                           user_id: user.id,
                           created_at: @timestamp,
                           updated_at: @timestamp })

      pe = PostEvent.new({ post_id: post.id, user_id: user.id, notes: 'Created', created_at: @timestamp })
      pe.post_created!
      pe.save

      post
    end
  end
end
