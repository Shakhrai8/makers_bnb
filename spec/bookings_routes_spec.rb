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
                
            }

        before(:each) do
            reset_makers_bnb_table
          end
        end
      end
      