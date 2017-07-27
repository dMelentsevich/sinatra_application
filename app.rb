require 'rubygems'
require 'sinatra'
require 'json'
require 'omniauth'
require 'omniauth-github'
require 'omniauth-facebook'
require 'sinatra/activerecord'
require './models/user'
require './models/menu_item'
require './models/order'

secrets = YAML.load_file('secrets.yml')

configure do
  set :sessions, true
  set :inline_templates, true
end

use OmniAuth::Builder do
  provider :github, secrets['github_key'], secrets['github_secret']
  provider :facebook, secrets['facebook_key'], secrets['facebook_secret']
end

get '/' do
  puts session[:authenticated]
  @users = User.all
  erb :index
end

get "/menu/all" do
  @menu = MenuItem.order(:id)
  erb :menu_all
end

get "/menu/new" do
    @menu = MenuItem.new
    erb :menu_new
end

post "/menu/new" do
    MenuItem.create(params[:menu])
    redirect "menu/all"
end

get "/menu/:id/edit" do
    @menu = MenuItem.find_by(id: params[:id])
    erb :menu_edit
end

patch "/menu/:id/edit" do
    @menu = MenuItem.find(params[:id])
    @menu.update(params[:menu])
    redirect "menu/all"
end

get "/menu/:id" do
    @menu = MenuItem.find(params[:id])
    erb :menu_item
end

delete "/menu/:id" do
    @menu = MenuItem.find(params[:id])
    @menu.destroy
    redirect("/menu/all")
    erb :menu_item
end

get "/order/all" do
    @order = Order.all
end

 
get '/auth/:provider/callback' do
  auth = request.env['omniauth.auth']
  @user = User.from_omniauth(auth)
  if !@user.nil?
    session[:user_id] = @user.id
    session[:user_name] = @user.name
    session[:authenticated] = true
    redirect '/'
  else 
    erb "<h1>Can's create session</h1><h3>message:<h3> <pre>#{params}</pre>"
  end
end

get '/auth/failure' do
  erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"
end

get '/logout' do
  session[:authenticated] = false
  puts session[:authenticated]
  redirect '/'
end
