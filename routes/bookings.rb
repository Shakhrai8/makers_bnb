require 'sinatra/base'
require_relative '../lib/repositories/spaces_repository'
require_relative '../lib/repositories/user_repository'
require_relative '../lib/repositories/booking_repository'

class Bookings < Sinatra::Base
  enable :sessions
  set :session_secret, "5cdde102f6f68294e1cff23f341aaaaf2d2725453eaccc8ebc239629e724fc53"

  get '/space/:space_id/new_booking' do
    redirect '/login' unless logged_in?
    space_id = params[:space_id].to_i

    # Retrieve the availability dates for the space
    @availability_dates = find_available_dates(space_id)
    erb :new_booking
  end

  post '/space/:space_id/new_booking' do
    redirect '/login' unless logged_in?
  
    space_id = params[:space_id].to_i
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])
  
    # Check if the selected dates are available
    if dates_available?(space_id, start_date, end_date)
      booking = Booking.new
      booking.space_id = params[:space_id].to_i
      booking.user_id = session[:user_id]
      booking.start_date = start_date
      booking.end_date = end_date
      booking.contents = params[:contents]

      BookingRepository.create(booking.space_id, booking.user_id, booking.start_date, booking.end_date, booking.contents)
      result = BookingRepository.all
  
      # Show a success message to the user
      erb :booking_success, locals: { space_id: result.last.space_id, booking_id: result.last.id }
    else
      redirect "/space/#{space_id}/new_booking?error=dates_unavailable"
    end
  end

  get '/space/:space_id/new_booking/:booking_id' do 
    redirect '/login' unless logged_in?
    space_id = params[:space_id]
    booking_id = params[:booking_id].to_i
    @booking = BookingRepository.find(booking_id)
    @user = UserRepository.find(@booking.user_id)
    @space = SpacesRepository.find(@booking.space_id)

    erb :booking
  end

  get '/space/:space_id/new_booking/:booking_id/delete' do
    redirect '/login' unless logged_in?

    booking_id = params[:booking_id].to_i
    @booking = BookingRepository.find(booking_id)

    erb :delete_booking
  end 

  post '/space/:space_id/new_booking/:booking_id/delete' do 
    redirect '/login' unless logged_in?

    booking_id = params[:booking_id].to_i
    @booking = BookingRepository.find(booking_id)

    BookingRepository.delete(booking_id)

    redirect '/profile'
  end 

  private

  def logged_in?
    !session[:user_id].nil?
  end

  def find_available_dates(space_id)
    query = "SELECT date FROM availability WHERE space_id = $1 AND is_available = true"
    result = DatabaseConnection.exec_params(query, [space_id])
  
    result.map { |row| Date.parse(row['date']) }
  end

  def dates_available?(space_id, start_date, end_date)
    query = 'SELECT COUNT(*) FROM availability WHERE space_id = $1 AND date >= $2 AND date <= $3 AND is_available = $4'
    query_params = [space_id, start_date, end_date, true]
  
    result = DatabaseConnection.exec_params(query, query_params)
  
    result[0]['count'].to_i == (end_date - start_date + 1).to_i
  end
end


