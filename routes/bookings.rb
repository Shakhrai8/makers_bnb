require 'sinatra/base'
require_relative '../lib/repositories/spaces_repository'
require_relative '../lib/repositories/user_repository'
require_relative '../lib/repositories/booking_repository'

class Spaces < Sinatra::Base
  enable :sessions
  set :session_secret, "5cdde102f6f68294e1cff23f341aaaaf2d2725453eaccc8ebc239629e724fc53"



  get '/space/:space_id/new_booking' do
    redirect '/login' unless logged_in?
    space_id = params[:space_id].to_i

    # Retrieve the availability dates for the space
    @availability_dates = find_by_space_id(space_id)
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
      booking.space_id = space_id
      booking.user_id = session[:user_id]
      booking.start_date = start_date
      booking.end_date = end_date
      booking.contents = params[:contents]
  
      BookingRepository.create(booking)
      result = BookingRepository.all
  
      # Perform additional logic for sending the request to the owner
      # This could include sending a notification or updating a request status
  
      # Show a success message to the user
      Swal.fire({
        icon: 'success',
        title: 'Request Sent',
        text: 'Your request has been sent to the owner.',
        confirmButtonText: 'OK'
      })
  
      redirect "/space/#{result.last.space_id}/new_booking/#{result.last.id}"
    else
      # Dates not available, handle accordingly (e.g., show an error message)
      # You can redirect to the new_booking page with an error message
      redirect "/space/#{space_id}/new_booking?error=dates_unavailable"
    end
  end
  
     

  get '/space/:space_id/new_booking/:booking_id' do 
    redirect '/login' unless logged_in?
    space_id = params[:space_id]
    booking_id = params[:booking_id].to_i
    @booking = BookingRepository.find(booking_id)

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

  def find_by_space_id(id)
    query = "SELECT * FROM availability WHERE id = $1;"
    result = DatabaseConnection.exec_params(query, [id])

    return nil if result.ntuples.zero?
    availability = Availability.new
    availability.id = result[0]['id'].to_i
    availability.date = result[0]['date']    #Date.parse(result[0]['date']).strftime('%Y-%m-%d')
    availability.is_available = result[0]['is_available']

    return availability
  end

  def dates_available?(space_id, start_date, end_date)
    query = 'SELECT date FROM availability WHERE space_id = $1 AND date >= $2 AND date <= $3 AND is_available = $4'
    query_params = [space_id, start_date, end_date, true]
  
    result = DatabaseConnection.exec_params(query, query_params)
  
    # If the number of available dates matches the selected date range,
    # then the dates are available
    result.ntuples == (end_date - start_date + 1).to_i
  end
end



