require 'sinatra'
require_relative '../models'
require_relative '../exceptions'

module Actions
  class VouchForPost
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

      raise BadRequest, 'Post must be by anonymous user to be vouched' unless post.user.anonymous

      champ = User.find_username(@champion_username)
      raise NotFound, 'User not found' if champ.nil?

      raise BadRequest, 'User is not a champion' unless champ.champion

      raise BadRequest, 'Already vouched by this user' if post.vouched_by?(champ)

      pe = PostEvent.new(post_id: post.id, user_id: champ.id,
                         notes: @notes,
                         created_at: @timestamp)
      pe.post_vouched!
      pe.save

      PostVoucher.create(post_id: post.id, user_id: champ.id)

      pe
    end
  end
end
