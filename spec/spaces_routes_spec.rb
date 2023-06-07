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

    describe "GET /feed" do
        it "renders the global_feed view" do
        get '/feed'

        expect(last_response.body).to include('MAKERS BnB - Global Feed')
        expect(last_response.body).to include('London Plaza')
        expect(last_response.body).to include('2 bedroom flat')
        expect(last_response.body).to include('60.5')
        expect(last_response.body).to include('Paris Cottage')
        expect(last_response.body).to include('Entire house')
        expect(last_response.body).to include('30.5')
        end
    end

    describe "GET /new_space" do
        context "when logged in" do
            it "renders the new_space view" do
                get '/new_space'

                expect(last_response.body).to include('MAKERS BnB - New Space')
                expect(last_response.body).to include('Name:')
                expect(last_response.body).to include('City:')
                expect(last_response.body).to include('Description:')
                expect(last_response.body).to include('Price:')
                expect(last_response.body).to include('Start Date:')
                expect(last_response.body).to include('End Date:')
            end
        end
        

        context "when not logged in" do
            it "redirects to the login page" do
                allow_any_instance_of(Spaces).to receive(:logged_in?).and_return(false)

                get '/new_space'

                expect(last_response).to be_redirect
                expect(last_response.location).to include('/login')
            end
        end
    end

    describe "POST /space/:space_id/edit" do
        context "when logged in" do
            xit "updates the space and redirects to the space view" do
            space_id = 1
            space = double("Space")
            allow(SpacesRepository).to receive(:find).with(space_id).and_return(space)
            allow(SpacesRepository).to receive(:update)

            allow_any_instance_of(Spaces).to receive(:logged_in?).and_return(true)

            post "/space/#{space_id}/edit", name: "Updated Space"

            expect(SpacesRepository).to have_received(:update).with(space)
            expect(last_response).to be_redirect
            expect(last_response.location).to include("/space/#{space_id}")
            end
        end

        context "when not logged in" do
            xit "redirects to the login page" do
            allow_any_instance_of(Spaces).to receive(:logged_in?).and_return(false)

            post '/space/1/edit'

            expect(last_response).to be_redirect
            expect(last_response.location).to include('/login')
            end
        end
    end

end
