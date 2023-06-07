require 'sinatra/base'
require_relative '../lib/repositories/user_repository'

class Users < Sinatra::Base
  enable :sessions
  set :session_secret, "5cdde102f6f68294e1cff23f341aaaaf2d2725453eaccc8ebc239629e724fc53"

  get '/signup' do
    if logged_in?
      redirect '/profile'
    else
      erb :signup
    end
  end

  post '/signup' do
    username = params[:username]
    email = params[:email]
    password = params[:password]

    UserRepository.create(username, email, password)

    redirect '/login'
  end

  get '/login' do
    if logged_in?
      redirect '/feed'
    else
      erb :login
    end
  end

  post '/login' do
    email = params[:email]
    password = params[:password]

    user = UserRepository.authenticate(email, password)

    if user
      session[:user_id] = user.id
      redirect '/profile'
    else
      redirect '/login'
    end
  end

  get '/profile' do
    if logged_in?
      @user = current_user
      profile_user_id = session[:user_id]
      @spaces = SpacesRepository.all.select { |space| space.user_id.to_i == profile_user_id }
      erb :profile
    else
      redirect '/login'
    end
  end
   

  get '/logout' do
    session.clear
    redirect '/'
  end

  private

  def logged_in?
    !session[:user_id].nil?
  end

  def current_user
    UserRepository.find(session[:user_id])
  end
end
