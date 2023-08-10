require 'rspec'
require 'rack/test'
require_relative 'database_helper'
require_relative '../app'

RSpec.describe 'Bookings' do
  include Rack::Test::Methods

  def app
    Bookings
  end

  let(:booking_params) do
    {
      space_id: 1,
      start_date: '2023-08-10',
      end_date: '2023-08-15',
      contents: 'Booking for a vacation'
    }
  end

  before(:each) do
    reset_makers_bnb_table
  end

  describe 'GET /space/:space_id/new_booking' do
    context 'when user is logged in' do
      before do
        get "/space/#{booking_params[:space_id]}/new_booking", {}, { 'rack.session' => { user_id: 1 } }
      end

      it 'renders the new booking page' do
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include('New Booking')
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        get "/space/#{booking_params[:space_id]}/new_booking"
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end
  end

  describe 'POST /space/:space_id/new_booking' do
    context 'when dates are available' do
      before do
        allow(BookingRepository).to receive(:all).and_return([double('Booking', id: 1, space_id: 1)])
      end

      xit 'creates a new booking and shows success message' do
        expect(BookingRepository).to receive(:create)
        post "/space/#{booking_params[:space_id]}/new_booking", booking_params, { 'rack.session' => { user_id: 1 } }
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq("/space/#{booking_params[:space_id]}/new_booking")
      end
    end

    context 'when dates are not available' do
      before do
        allow_any_instance_of(Bookings).to receive(:dates_available?).and_return(false)
      end

      it 'redirects with error message' do
        post "/space/#{booking_params[:space_id]}/new_booking", booking_params, { 'rack.session' => { user_id: 1 } }
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq("/space/#{booking_params[:space_id]}/new_booking")
      end
    end
  end

  describe 'GET /space/:space_id/new_booking/:booking_id' do
    context 'when user is logged in' do
      xit 'renders the booking details page' do
        allow(BookingRepository).to receive(:find).and_return(double('Booking', id: 1, user_id: 1, space_id: 1))
        get "/space/#{booking_params[:space_id]}/new_booking/1", {}, { 'rack.session' => { user_id: 1 } }
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include('Booking Details')
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        get "/space/#{booking_params[:space_id]}/new_booking/1"
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end
  end

  describe 'GET /space/:space_id/new_booking/:booking_id/delete' do
    context 'when user is logged in' do
      it 'renders the delete booking page' do
        get "/space/#{booking_params[:space_id]}/new_booking/1/delete", {}, { 'rack.session' => { user_id: 1 } }
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include('Delete Booking')
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        get "/space/#{booking_params[:space_id]}/new_booking/1/delete"
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end
  end

  describe 'POST /space/:space_id/new_booking/:booking_id/delete' do
    context 'when user is logged in' do
      it 'deletes the booking and redirects to profile' do
        expect(BookingRepository).to receive(:delete)
        post "/space/#{booking_params[:space_id]}/new_booking/1/delete", {}, { 'rack.session' => { user_id: 1 } }
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/profile')
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        post "/space/#{booking_params[:space_id]}/new_booking/1/delete"
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end
  end
end
