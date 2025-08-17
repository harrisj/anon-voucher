require 'sinatra'
require_relative '../models'
require_relative '../exceptions'

module Actions
  class UnvouchForPost
    def initialize(post_id:, username:, notes:, timestamp: nil)
      @post_id = post_id
      @champion_username = username
      @notes = notes
      @timestamp = timestamp || Time.now
    end

    def run
      post = Post[@post_id]

      raise NotFound, 'Post not found' if post.nil?
      raise NotFound, 'Post user not found' unless post.user

      champ = User.find_username(@champion_username)
      raise NotFound, 'User not found' if champ.nil?

      raise BadRequest, "Post isn't vouched by this user" unless post.vouched_by?(champ)

      pe = PostEvent.new(post_id: post.id, user_id: champ.id,
                         notes: @notes, created_at: @timestamp)
      pe.post_unvouched!
      pe.save

      pv = PostVoucher.where(post_id: post.id, user_id: champ.id).first
      pv.delete

      pe
    end
  end
end
