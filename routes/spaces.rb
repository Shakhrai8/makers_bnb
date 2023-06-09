require 'sinatra/base'
require 'dotenv/load'
require_relative '../lib/repositories/spaces_repository'
require_relative '../lib/repositories/user_repository'
require_relative '../lib/repositories/photo_repository'
require_relative '../config'
require 'httparty'
require 'cgi'
require 'unsplash'
require_relative '../lib/models/availability'
require_relative '../lib/models/space'

class Spaces < Sinatra::Base
  enable :sessions
  set :session_secret, "5cdde102f6f68294e1cff23f341aaaaf2d2725453eaccc8ebc239629e724fc53"

  Unsplash.configure do |config|
    config.application_access_key = ENV['UNSPLASH_ACCESS_KEY']
    config.application_secret = ENV['UNSPLASH_SECRET_KEY']
    config.application_redirect_uri = "http://localhost:9292/oauth/callback"
    config.utm_source = "air bnb clone exercise"
  end

  get '/feed' do
    @spaces = SpacesRepository.all
    erb :global_feed
  end

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

    set_default_availability(SpacesRepository.all.last.id, space.start_date, space.end_date)

    redirect "/space/#{SpacesRepository.all.last.id}"
  end

  get '/space/:space_id' do
    redirect '/profile' unless logged_in?
  
    space_id = params[:space_id].to_i
    @space = SpacesRepository.find(space_id)
    @photos = PhotoRepository.find_by_space_id(space_id)
    this = @space.city
    
    # Retrieve weather information for the city
    weather_info = get_weather_info(this)
    @temperature = weather_info['temperature']
    @weather_description = weather_info['description']
  
    # Retrieve a random background image from Unsplash
    unsplash = Unsplash::Client.new(
      access_key: Unsplash.configuration.application_access_key,
      secret_key: Unsplash.configuration.application_secret
    )
    photo = Unsplash::Photo.random(query: @space.city)
    @background_image = photo.urls.regular

    erb :space
  end

  post '/space/:space_id/photos/add' do
    space_id = params[:space_id].to_i
    photo_url = params[:photo_url]
  
    # Call the create method from the PhotoRepository to add the photo
    PhotoRepository.create(space_id, photo_url)
  
    redirect back
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

  def current_user
    UserRepository.find(session[:user_id])
  end

  def get_weather_info(city)
    weather_api_key = ENV['WEATHER_API_KEY']
    units = 'metric'  # Use 'metric' for Celsius or 'imperial' for Fahrenheit
    lang = 'en'  # Specify the language for the weather information
  
    geocoding_url = "http://api.openweathermap.org/geo/1.0/direct?q=#{city}&limit=1&appid=#{weather_api_key}"
  
    geocoding_response = HTTParty.get(geocoding_url)
    return {} unless geocoding_response.code == 200
  
    geocoding_data = JSON.parse(geocoding_response.body)
    return {} if geocoding_data.empty?
  
    lat = geocoding_data[0]['lat']
    lon = geocoding_data[0]['lon']
  
    weather_url = "https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&units=#{units}&lang=#{lang}&appid=#{weather_api_key}"
  
    weather_response = HTTParty.get(weather_url)
    return {} unless weather_response.code == 200
  
    weather_data = JSON.parse(weather_response.body)
    {
      'temperature' => weather_data['main']['temp'],
      'description' => weather_data['weather'][0]['description']
    }
  end 
  
  def set_default_availability(space_id, start_date, end_date)
    current_date = start_date

    while current_date <= end_date
      # Create a new availability record for each date
      availability = Availability.new
      availability.space_id = space_id
      availability.date = current_date.to_s
  
      # Save the availability record to the database
      sql = "INSERT INTO availability (space_id, date) VALUES ($1, $2)"
      params = [availability.space_id, availability.date]
      DatabaseConnection.exec_params(sql, params)
  
      # Increment the current date by 1 day
      current_date = current_date.next
    end
  end 
end
