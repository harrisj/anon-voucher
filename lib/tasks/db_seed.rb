# frozen_string_literal: true

require_relative '../models'
require_relative '../actions/create_post'
require_relative '../actions/vouch_post'
require 'yaml'

# HACK: In a production system, this would likely be prettier and even maybe
# even employ flexible systems for creating data like FactoryBot
class Database
  def reset_all_tables!
    reset_all_posts!
    User.truncate
  end

  def reset_all_posts!
    PostVoucher.truncate
    PostEvent.truncate
    Post.truncate
  end

  def load_users_posts
    seed_file = File.join(File.dirname(__FILE__), '..', '..', 'test', 'seeds.yaml')
    users = YAML.unsafe_load_file(seed_file, symbolize_names: true)

    users.each do |user_hash|
      user = User.create(user_hash.except(:posts))

      next unless user_hash[:posts]

      user_hash[:posts].each do |post_hash|
        timestamp = Time.now - ((post_hash[:delta_min] || 0) * 60)
        p = Actions::CreatePost.new(username: user.username, text: post_hash[:text],
                                    timestamp: timestamp).run

        next unless post_hash[:vouched]

        post_hash[:vouched].each do |v|
          timestamp = Time.now - ((v[:delta_min] || 0) * 60)
          Actions::VouchForPost.new(post_id: p.id, username: v[:user], notes: v[:notes], timestamp: timestamp).run
        end
      end
    end
  end

  def reseed
    reset_all_tables!
    load_users_posts
  end
end
