require 'sinatra'
require 'kramdown'

require_relative 'lib/models'
require_relative 'lib/actions/create_post'
require_relative 'lib/actions/vouch_post'

get '/' do
  markdown :index
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
  erb :_posts_timeline, locals: { posts: posts, current_user: user }
end

post '/actions/vouch/:id' do |id|
end

post '/actions/unvouch/:id' do |id|
end

post '/reset' do
end
