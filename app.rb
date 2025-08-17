require 'sinatra'
require 'kramdown'

require_relative 'lib/models'
# require_relative 'lib/actions'

get '/' do
  markdown :index
end

get '/timeline/:username' do |username|
  user = User.find_username(username)
  raise NotFound, 'User not found' if user.nil?

  posts = Post.order_by(:created_at).all
  erb :timeline, locals: { posts: posts, user: user }
end

post '/actions/vouch/:id' do |id|
end

post '/actions/unvouch/:id' do |id|
end

post '/reset' do
end
