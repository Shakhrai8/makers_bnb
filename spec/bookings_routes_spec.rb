require_relative 'database_helper'
require 'rspec'
require_relative '../app'
require 'rack/test'


describe Spaces do
  include Rack::Test::Methods

  def app
    Spaces
  end

  let(:session) { { user_id: 1 } }

  before do
    allow_any_instance_of(Spaces).to receive(:session).and_return(session)
  end

  before(:each) do
    reset_makers_bnb_table
  end


  describe "GET '/space/:space_id/new_booking'" do
    context "when logged in" do

      it "renders the new_booking view" do
        get '/space/1/new_booking'

        expect(last_response.body).to include('New Booking')
        expect(last_response.body).to include('Start Date:')
        expect(last_response.body).to include('End Date:')
        expect(last_response.body).to include('Contents:')
        expect(last_response.body).to include('Status:')
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        allow_any_instance_of(Spaces).to receive(:logged_in?).and_return(false)

        get '/space/1/new_booking'

        expect(last_response).to be_redirect
        expect(last_response.location).to include('/login')
      end
    end
  end

  describe "POST '/space/:space_id/new_booking'" do
    context "when the booking exists" do
      before do
        # Mock the BookingRepository's find method to return a booking
        @booking_id = 789
        @booking = double('Booking', id: @booking_id)
        allow(BookingRepository).to receive(:find).with(@booking_id).and_return(@booking)

        # Perform the GET request
        get "/space/123/new_booking/#{@booking_id}"
      end
    end

    context "when the booking does not exist" do
        before do
          # Mock the BookingRepository's find method to return nil
          @booking_id = 999
          allow(BookingRepository).to receive(:find).with(@booking_id).and_return(nil)

          # Perform the GET request
          get "/space/123/new_booking/#{@booking_id}"
        end

      xit "renders a 'Booking Not Found' message" do
        expect(last_response).to be_ok
        expect(last_response.body).to include('Booking Not Found')
      end

      xit "creates a new booking and redirects to the booking view" do
        allow_any_instance_of(Spaces).to receive(:logged_in?).and_return(true)

        post "/space/#{space_id}/new_booking", start_date: '2023-06-10', end_date: '2023-06-12', contents: 'Booking contents', status: 'confirmed'

        expect(BookingRepository).to have_received(:create).with(space_id, session[:user_id], '2023-06-10', '2023-06-12', 'Booking contents', 'confirmed')
        expect(last_response).to be_redirect
        expect(last_response.location).to include("/booking/#{booking_id}")
      end
    end
  end


  describe "GET '/booking/:booking_id/delete'" do
    context "when logged in" do
      let(:booking_id) { 1 }
      let(:booking) { double("Booking") }

      before do
        allow(BookingRepository).to receive(:find).with(booking_id).and_return(booking)
      end

      xit "renders the delete_booking view" do
        allow_any_instance_of(Spaces).to receive(:logged_in?).and_return(true)

        get "/booking/#{booking_id}/delete"

        expect(last_response).to be_ok
        expect(last_response.body).to include('Delete Booking')
        expect(last_response.body).to include('Are you sure you want to delete this booking?')
      end
    end

    context "when not logged in" do
      xit "redirects to the login page" do
        allow_any_instance_of(Spaces).to receive(:logged_in?).and_return(false)

        get '/booking/1/delete'

        expect(last_response).to be_redirect
        expect(last_response.location).to include('/login')
      end
    end
  end

  describe "POST '/booking/:booking_id/delete'" do
    context "when logged in" do
      let(:booking_id) { 1 }
      let(:booking) { double("Booking") }

      before do
        allow(BookingRepository).to receive(:find).with(booking_id).and_return(booking)
        allow(BookingRepository).to receive(:delete)
      end

      it "deletes the booking and redirects to the profile" do
        allow_any_instance_of(Spaces).to receive(:logged_in?).and_return(true)

        post "/booking/#{booking_id}/delete"

        expect(BookingRepository).to have_received(:delete).with(booking_id)
        expect(last_response).to be_redirect
        expect(last_response.location).to include('/profile')
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        allow_any_instance_of(Spaces).to receive(:logged_in?).and_return(false)

        post '/booking/1/delete'

        expect(last_response).to be_redirect
        expect(last_response.location).to include('/login')
      end
    end
  end
end
