require 'sinatra/base'
require_relative '../lib/repositories/user_repository'
require_relative '../lib/repositories/booking_repository'
require_relative '../lib/repositories/message_repository'

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
      @bookings = BookingRepository.all.select { |booking| booking.user_id.to_i == profile_user_id }
      erb :profile
    else
      redirect '/login'
    end
  end
  
  get '/profile/requests' do
    if logged_in?
      @user = current_user
      profile_user_id = session[:user_id]
      @incoming_requests = BookingRepository.incoming_requests(profile_user_id)
      @sent_requests = BookingRepository.sent_requests(profile_user_id)
      erb :requests
    else
      redirect '/login'
    end
  end

  post '/requests/approve/:id' do
    if logged_in?
      request_id = params[:id]
    
      BookingRepository.update_status(request_id, 'accepted')
    
      booking = BookingRepository.find(request_id)
    
      message = "Your booking request for #{BookingRepository.find_space_name(booking.space_id)} has been accepted."
      MessageRepository.create_notification(booking.user_id, current_user.id, message)  
    
      redirect 'profile/requests'
    else
      redirect '/login'
    end
  end
  
  post '/requests/decline/:id' do
    if logged_in?
      request_id = params[:id]
    
      BookingRepository.update_status(request_id, 'declined')
    
      booking = BookingRepository.find(request_id)
    
      message = "Your booking request for #{BookingRepository.find_space_name(booking.space_id)} has been declined."
      MessageRepository.create_notification(booking.user_id, current_user.id, message)  
    
      redirect 'profile/requests'
    else
      redirect '/login'
    end
  end
  
  get '/profile/notifications' do
    if logged_in?
      user_id = session[:user_id] 
    
      notifications = MessageRepository.find_notifications(user_id)

      search = UserRepository.find(notifications[0].sender_id)
      @sender_name = search.username
    
      erb :notifications, locals: { notifications: notifications }
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
