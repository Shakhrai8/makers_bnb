require_relative '../lib/repositories/booking_repository'
require_relative 'database_helper'


RSpec.describe BookingRepository do
    before(:each) do 
      reset_makers_bnb_table
    end
  
    context '.create' do 
        it 'creates a booking' do 
            BookingRepository.create('1', '1', "2023-06-10", '2023-06-15', 'Need an extra chair')

            result = BookingRepository.all
            expect(result[2].contents).to eq('Need an extra chair')
            expect(result[2].status).to eq('pending')
        end 
    end 

    context '.find' do 
        it 'finds a booking using booking_id' do
            booking = BookingRepository.find(1)

            expect(booking.contents).to eq ('I would like an extra bed')
        end 
    end 

    context '.update' do 
        it 'updates a booking' do 
            booking = Booking.new 
            booking.space_id = 1
            booking.user_id = 1
            booking.start_date = '2023-06-15'
            booking.end_date = '2023-06-19'
            booking.contents = 'Breakfast?'

            BookingRepository.update(booking)

            new_bookings = BookingRepository.find(1)
            expect(new_bookings.contents).to eq('Breakfast?')
        end 
    end 
    
    context '.delete' do 
        it 'deletes a booking' do 
            BookingRepository.delete(1)
            list = BookingRepository.all
            expect(list.length).to eq(1)
            expect(list.last.contents).to eq('No requests')
        end 
    end

    context '.all' do 
        it 'displays all bookings' do
        bookings = BookingRepository.all 

        expect(bookings.length).to eq(2)
        expect(bookings[0].contents).to eq('I would like an extra bed')
        end 
    end 
end 




