# frozen_string_literal: true

require 'sinatra'
require 'kramdown'

require_relative 'lib/models'
require_relative 'lib/tasks/db_seed'
require_relative 'lib/actions/create_post'
require_relative 'lib/actions/vouch_post'
require_relative 'lib/actions/unvouch_post'

class App < Sinatra::Base
  set :markdown, layout_engine: :erb
  set :host_authorization, {
    permitted_hosts: ['localhost', 'anon-voucher.fly.dev'],
    message: 'This host is not permitted'
  }

  get '/' do
    markdown :index, layout: :md_layout
  end

  get '/timeline/:username' do |username|
    user = User.find_username(username)
    raise NotFound, 'User not found' if user.nil?

    posts = Post.order_by(Sequel.desc(:created_at)).all
    erb :timeline, locals: { posts: posts, current_user: user }
  end

  post '/actions/post' do
    content = params[:content]
    username = params[:username]
    user = User.find_username(username)

    Actions::CreatePost.new(username: username, text: content).run

    posts = Post.order_by(Sequel.desc(:created_at)).all
    erb :_posts_timeline, locals: { posts: posts, current_user: user }, layout: false
  end

  post '/actions/vouch/:id' do |post_id|
    notes = params[:notes]
    username = params[:username]
    user = User.find_username(username)

    Actions::VouchForPost.new(post_id: post_id, username: username, notes: notes).run

    post = Post[post_id]
    erb :_post, locals: { post: post, current_user: user }, layout: false
  end

  post '/actions/unvouch/:id' do |post_id|
    notes = params[:notes]
    username = params[:username]
    user = User.find_username(username)

    Actions::UnvouchForPost.new(post_id: post_id, username: username, notes: notes).run

    post = Post[post_id]
    erb :_post, locals: { post: post, current_user: user }, layout: false
  end

  get '/danger/reset' do
    DB.reseed
    redirect '/'
  end
end
