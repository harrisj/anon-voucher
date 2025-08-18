# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/exceptions'
require_relative '../../lib/tasks/db_seed'
require_relative '../../lib/actions/vouch_post'
require_relative '../../lib/actions/unvouch_post'

class TestUnvouchPost < Minitest::Test
  def setup
    DB.reseed
  end

  def test_unvouch_cant_find_post
    champion = User.where(champion: true).first

    assert_raises NotFound do
      Actions::UnvouchForPost.new(post_id: 929_022_929_292, username: champion, notes: 'foo bar').run
    end
  end

  def test_cant_unvouch_post_we_didnt_vouch
    anon_post = Post.anonymous.first
    refute_nil anon_post
    assert anon_post.user.anonymous

    champion = User.where(champion: true).first
    refute_nil champion

    champ2 = User.create(username: 'test_champ2', display_name: 'Test Champ 2', champion: true)
    Actions::VouchForPost.new(post_id: anon_post.id, username: champ2.username, notes: 'baz quux').run
    anon_post = Post[anon_post.id] # reload
    refute_nil anon_post
    assert anon_post.vouched?
    assert anon_post.vouched_by?(champ2)
    refute anon_post.vouched_by?(champion)

    assert_raises BadRequest do
      Actions::UnvouchForPost.new(post_id: anon_post.id, username: champion.username, notes: 'blah blah').run
    end
  end

  def test_normal_unvouch
    anon_post = Post.anonymous.first
    refute_nil anon_post
    assert anon_post.user
    assert anon_post.user.anonymous
    refute anon_post.vouched?

    champ = User.where(champion: true).first
    refute_nil champ
    assert champ.champion

    Actions::VouchForPost.new(post_id: anon_post.id, username: champ.username, notes: 'blah blah').run
    anon_post = Post[anon_post.id] # reload
    assert anon_post.vouched?
    assert anon_post.vouched_by? champ

    # Now let's unvouch
    Actions::UnvouchForPost.new(post_id: anon_post.id, username: champ.username, notes: 'changed my mind').run
    anon_post = Post[anon_post.id] # reload
    refute anon_post.vouched?
    refute anon_post.vouched_by? champ

    # Should have two events
    pe_events = PostEvent.where(user_id: champ.id).all
    assert_equal 2, pe_events.count
    assert pe_events[0].post_vouched?
    assert pe_events[1].post_unvouched?
    assert_equal 'changed my mind', pe_events[1].notes

    # Vouch again
    Actions::VouchForPost.new(post_id: anon_post.id, username: champ.username, notes: 'changing mind back').run
    anon_post = Post[anon_post.id] # reload
    assert anon_post.vouched?
    assert anon_post.vouched_by? champ
    pe_events = PostEvent.where(user_id: champ.id).all
    assert_equal 3, pe_events.count
  end
end
