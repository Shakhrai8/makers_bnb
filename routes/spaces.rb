require 'sinatra/base'
require_relative '../lib/repositories/spaces_repository'
require_relative '../lib/repositories/user_repository'

class Spaces < Sinatra::Base
  enable :sessions
  set :session_secret, "5cdde102f6f68294e1cff23f341aaaaf2d2725453eaccc8ebc239629e724fc53"

  get '/new_space' do
    redirect '/login' unless logged_in?

    erb :new_space
  end

  post '/new_space' do
    redirect '/login' unless logged_in?

    space = Space.new
    space.name = params[:name]
    space.city = params[:city]
    space.description = params[:description]
    space.price = params[:price]
    space.start_date = params[:start_date]
    space.end_date = params[:end_date]
    space.user_id = session[:user_id]

    SpacesRepository.create(
      space.name, space.city, space.description, space.price,
      space.start_date, space.end_date, space.user_id
    )

    redirect "/space/#{SpacesRepository.all.last.id}"
  end

  get '/space/:space_id' do
    redirect '/profile' unless logged_in?

    space_id = params[:space_id].to_i
    @space = SpacesRepository.find(space_id)

    erb :space
  end

  get '/space/:space_id/edit' do
    redirect '/login' unless logged_in?
  
    space_id = params[:space_id].to_i
    space = SpacesRepository.find(space_id)
  
    #redirect "/space/#{space_id}/edit" unless space && space.user_id == session[:user_id]
  
    erb :update_space, locals: { space: space }
  end

  post '/space/:space_id/edit' do
    redirect '/login' unless logged_in?

    space_id = params[:space_id].to_i
    space = SpacesRepository.find(space_id)

    #redirect '/profile' unless space && space.user_id == session[:user_id]

    space.name = params[:name]
    space.city = params[:city]
    space.description = params[:description]
    space.price = params[:price]
    space.start_date = params[:start_date]
    space.end_date = params[:end_date]

    SpacesRepository.update(space)

    redirect "/space/#{space_id}"
  end

  get '/space/:space_id/delete' do
    redirect '/login' unless logged_in?
  
    space_id = params[:space_id].to_i
    @space = SpacesRepository.find(space_id)
  
    erb :delete_space
  end

  post '/space/:space_id/delete' do
    redirect '/login' unless logged_in?

    space_id = params[:space_id].to_i
    @space = SpacesRepository.find(space_id)

    #redirect '/profile' unless space && space.user_id == session[:user_id]

    SpacesRepository.delete(space_id)

    redirect '/profile'
  end

  private

  def logged_in?
    !session[:user_id].nil?
  end
end
