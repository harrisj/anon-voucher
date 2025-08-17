require 'minitest/autorun'
require_relative '../../lib/exceptions'
require_relative '../../lib/tasks/db_seed'
require_relative '../../lib/actions/create_post'

class TestCreatePost < Minitest::Test
  def setup
    DB.reset_all_tables!
    @username = 'test_user'
    @user = User.create(username: @username, display_name: 'Test User')
  end

  def test_user_not_found
    assert_raises NotFound do
      Actions::CreatePost.new('foobarbaz', 'This is a new post').run
    end
  end

  def test_post_empty_text
    assert_raises BadRequest do
      Actions::CreatePost.new(@username, '').run
    end
  end

  def test_post_normal
    post_text = 'This is another test of posting stuff'
    Actions::CreatePost.new(@username, post_text).run

    user = User.find_username(@username)
    refute_nil user
    refute_empty user.posts
    assert_equal 1, user.posts.count

    post = user.posts[0]
    assert_equal post_text, post.text
    assert_equal user, post.user
    refute_nil post.created_at
    refute_nil post.updated_at

    assert_equal 1, post.post_events.count
    post_event = post.post_events.first
    assert_equal post.id, post_event.post_id
    assert_equal user.id, post_event.user_id
    assert post_event.post_created?
  end
end
