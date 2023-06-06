require_relative '../lib/repositories/listings_repository'
require_relative 'database_helper'

RSpec.describe ListingsRepository do
  before(:each) do 
    reset_makers_bnb_table
  end

    context '.all' do
        it 'displays all listings' do
            listing = ListingRepository.all

            expect(listing.length).to eq(2)
            expect(result).to include('London Plaza')
        end
    end


    context '.create' do
        it 'creates a new listing in the database' do
            ListingsRepository.create('The Ritz', 'Cornwall', '3 bedroom flat', '70.50', '2023-05-05', '2023-06-20', NOW(), NOW(), 1)
            listing = ListingRepository.all 

            expect(listing.last.name).to eq('The Ritz')
            expect(listing.last.city).to eq('Cornwall')
            expect(listing.length).to eq(3)
            expect(listing.last.id).to eq(3)
        end
    end
end

    

    #Creates a new listing

    

    #finds a listing by id

    listing = ListingsRepository.find(2)

    expect(listing.name).to eq('paris cottage')

