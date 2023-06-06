require 'sinatra/base'
require_relative '../lib/repositories/spaces_repository'
require_relative '../lib/repositories/user_repository'

class Spaces < Sinatra::Base
  enable :sessions
  set :session_secret, "5cdde102f6f68294e1cff23f341aaaaf2d2725453eaccc8ebc239629e724fc53"

  get '/new_space' do 
    if logged_in?
        erb :new_space
    else
        redirect '/login'
    end 
  end

  post '/new_space' do
    if logged_in?
      @space = Space.new
        @space.name = params[:name]
        @space.city = params[:city]
        @space.description = params[:description]
        @space.price = params[:price]
        @space.start_date = params[:start_date]
        @space.end_date = params[:end_date]
        @space.user_id = session[:user_id]

        SpacesRepository.create(@space.name, @space.city, @space.description, @space.price, @space.start_date, @space.end_date, @space.user_id)

        erb: space
    else
        redirect '/login'
    end
  end

  get '/:space_id/update' do
    if logged_in?
        space_id = params[:space_id].to_i
        space = SpacesRepository.find(space_id)

        if space
            name = params[:name]
            city = params[:city]
            description = params[:description]
            price = params[:price]
            start_date = params[:start_date]
            end_date = params[:end_date]
            user_id = session[:user_id]

            SpacesRepository.update(name, city, description, price, start_date, end_date, user_id)

            redirect '/:space_id'
        else
            redirect '/profile'
        end
    else
        redirect '/login'
    end
  end

  get '/space/:space_id' do
    if logged_in?
      space_id = params[:space_id].to_i
      space = SpacesRepository.find(space_id)

      erb: space, locals: {space: space}
    else
      redirect '/profile'
    end
  end


  delete '/:space_id/delete' do 
    if logged_in?
      space_id = params[:space_id].to_i
      SpacesRepository.delete(space_id)
      redirect '/profile'
    else 
        redirect '/login'
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
