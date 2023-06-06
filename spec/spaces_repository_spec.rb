require_relative '../lib/repositories/spaces_repository'
require_relative 'database_helper'

RSpec.describe SpacesRepository do
  before(:each) do 
    reset_makers_bnb_table
  end

    context '.all' do
        it 'displays all spaces' do
        spaces = SpacesRepository.all

            expect(spaces.length).to eq(2)
            expect(spaces[0].name).to eq('London Plaza')
        end
    end


    context '.create' do
        it 'creates a newspaces in the database' do
        SpacesRepository.create('The Ritz', 'Cornwall', '3 bedroom flat', '70.50', '2023-05-05', '2023-06-20', 1)
            spaces = SpacesRepository.all 

            expect(spaces.last.name).to eq('The Ritz')
            expect(spaces.last.city).to eq('Cornwall')
            expect(spaces.length).to eq(3)
            expect(spaces.last.id).to eq(3)
        end
    end

    context '.find' do
        it 'finds a single listing by id' do
            spaces = SpacesRepository.find(2)

            expect(spaces.name).to eq('Paris Cottage')
        end
    end
end

    



    




