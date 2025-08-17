require 'sinatra'
require_relative '../models'

module Actions
  class CreatePost
    def initialize(username, text)
      @username = username
      @text = text
    end

    def run
      user = User.find_username(@username)

      raise NotFound, 'User not found' if user.nil?

      raise BadRequest, 'Post text must not be blank' if @text.nil? || @text.empty?

      post = Post.create({ text: @text,
                           user_id: user.id,
                           created_at: Time.now,
                           updated_at: Time.now })

      pe = PostEvent.new({ post_id: post.id, user_id: user.id, created_at: Time.now })
      pe.post_created!
      pe.save
    end
  end
end
