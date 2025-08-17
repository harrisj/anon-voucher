require 'minitest/autorun'
require_relative '../../lib/exceptions'
require_relative '../../lib/models'
require_relative '../../lib/tasks/db_seed'
require_relative '../../lib/actions/vouch_post'

class TestVouchPost < Minitest::Test
  def setup
    DB.reseed
  end

  def test_vouch_cant_find_post
    champion = User.where(champion: true).first

    assert_raises NotFound do
      action = Actions::VouchForPost.new(post_id: 929_022_929_292, username: champion.username, notes: 'foo bar')
      action.run
    end
  end

  def test_cant_vouch_non_anonymous_post
    non_anon_post = Post.not_anonymous.first
    refute_nil non_anon_post
    refute non_anon_post.user.anonymous

    champion = User.where(champion: true).first
    refute_nil champion

    assert_raises BadRequest do
      Actions::VouchForPost.new(post_id: non_anon_post.id, username: champion.username, notes: 'foo bar').run
    end
  end

  def test_regular_user_cant_vouch
    anon_post = Post.anonymous.first
    refute_nil anon_post
    assert anon_post.user.anonymous

    regular_user = User.where(champion: false).first
    refute_nil regular_user
    refute regular_user.champion

    assert_raises BadRequest do
      Actions::VouchForPost.new(post_id: anon_post.id, username: regular_user.username, notes: 'more notes').run
    end
  end

  def test_normal_vouch
    anon_post = Post.anonymous.first
    assert anon_post.user
    assert anon_post.user.anonymous
    refute_nil anon_post
    refute anon_post.vouched?

    champ = User.where(champion: true).first
    refute_nil champ
    assert champ.champion

    Actions::VouchForPost.new(post_id: anon_post.id, username: champ.username, notes: 'foo bar').run

    pe = PostEvent.where(post_id: anon_post.id, user_id: champ.id).first
    refute_nil pe
    assert_equal 'foo bar', pe.notes
    assert pe.post_vouched?

    anon_post = Post[anon_post.id] # reload
    assert anon_post.vouched?
    assert anon_post.vouched_by? champ

    # Throw error if try to vouch again
    assert_raises BadRequest do
      Actions::VouchForPost.new(post_id: anon_post.id, username: champ.username, notes: 'baz quux').run
    end
  end
end
