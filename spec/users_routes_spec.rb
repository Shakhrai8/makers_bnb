require 'rspec'
require 'rack/test'
require_relative 'database_helper'
require_relative '../app'

RSpec.describe 'Users' do
  include Rack::Test::Methods

  def app
    Users
  end

  let(:user_params) do
    {
      username: 'johndoe',
      email: 'john@example.com',
      password: 'password'
    }
  end

  before(:each) do
    reset_makers_bnb_table
  end

  describe 'POST /signup' do
    it 'creates a new user and sets the session user_id' do
      expect(UserRepository).to receive(:create).with(
        user_params[:username],
        user_params[:email],
        user_params[:password]
      ).and_return(1) # Assuming the returned user_id is an integer

      post '/signup', user_params

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end
  end

  describe 'POST /login' do
    let(:existing_user) { double('User', id: 1) } # Assuming the existing user_id is an integer

    before do
      allow(UserRepository).to receive(:authenticate).and_return(existing_user)
    end

    context 'with valid credentials' do
      it 'sets the session user_id and redirects to profile' do
        post '/login', email: user_params[:email], password: user_params[:password]

        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/profile')
      end
    end

    context 'with invalid credentials' do
      before do
        allow(UserRepository).to receive(:authenticate).and_return(nil)
      end

      it 'redirects to login page' do
        post '/login', email: user_params[:email], password: user_params[:password]

        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end
  end

  describe 'GET /profile' do
    context 'when user is logged in' do
      let(:user) { double('User', id: 1, username: 'johndoe', email: 'john@example.com') } # Assuming the user_id is an integer

      before do
        allow(UserRepository).to receive(:find).with(1).and_return(user) # Assuming the user_id is an integer
        get '/profile', {}, { 'rack.session' => { user_id: 1 } } # Assuming the user_id is an integer
      end

      it 'renders the profile page' do
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include('My Profile')
        expect(last_response.body).to include('Welcome, johndoe')
        expect(last_response.body).to include('Email: john@example.com')
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        get '/profile'

        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end
  end

  describe 'GET /logout' do
    it 'clears the session and redirects to login page' do
      get '/logout', {}, { 'rack.session' => { user_id: 1 } } # Assuming the user_id is an integer

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.session[:user_id]).to be_nil
      expect(last_request.path).to eq('/')
    end
  end
end

