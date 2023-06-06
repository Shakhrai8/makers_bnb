require 'sinatra/base'
require_relative '../lib/repositories/space_repository'
require_relative '../lib/repositories/user_repository'

class Spaces < Sinatra::Base
  enable :sessions
  set :session_secret, "5cdde102f6f68294e1cff23f341aaaaf2d2725453eaccc8ebc239629e724fc53"

  get '/new-space' do 
    if logged_in?
        erb :new_space
    else
        redirect '/login'
    end 
  end

  post '/new-space' do
    if logged_in?
        name = params[:name]
        city = params[:city]
        description = params[:description]
        price = params[:price]
        start_date = params[:start_date]
        end_date = params[:end_date]
        user_id = session[:user_id]

        SpaceRepository.create(name, city, description, price, start_date, end_date, user_id)

        erb :new_space
    else
        redirect '/login'
    end
  end

  patch '/:space_id/update' do
    if logged_in?
        space_id = params[:space_id].to_i
        space = SpaceRepository.find(space_id)

        if space
            name = params[:name]
            city = params[:city]
            description = params[:description]
            price = params[:price]
            start_date = params[:start_date]
            end_date = params[:end_date]
            user_id = session[:user_id]

            SpaceRepository.update(name, city, description, price, start_date, end_date, user_id)

            redirect '/:space_id'
        else
            redirect '/profile'
        end
    else
        redirect 'login'
    end
    end

  private

  def logged_in?
    !session[:user_id].nil?
  end

  def current_user
    UserRepository.find(session[:user_id])
  end
end

=begin
## Create a new space
Requests:
GET, POST /new-space
Response (200 0K):
It will create a new space

## Update the space
Requests:
PATCH /:space_id/update
Response (200 0K):
It will update the space

## Delete the space
Requests:
DELETE /:space_id/delete
Response (200 0K):
It will delete the space
=end