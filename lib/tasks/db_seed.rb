require_relative '../models'
require 'yaml'

# HACK: In a production system, this would likely be prettier and even maybe
# even employ flexible systems for creating data like FactoryBot
class Database
  def reset_all_tables!
    reset_all_posts!
    User.truncate
  end

  def reset_all_posts!
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
        Post.create(post_hash.merge(user_id: user.id))
      end
    end
  end

  def reseed
    reset_all_tables!
    load_users_posts
  end
end
