require_relative '../models/booking'

class BookingRepository 

    def self.create(space_id, user_id, start_date, end_date, contents)
        query = 'INSERT INTO bookings (space_id, user_id, start_date, end_date, contents) VALUES ($1, $2, $3, $4, $5);'
        DatabaseConnection.exec_params(query, [space_id, user_id, start_date, end_date, contents])
        #CHECK WHETHER WE SHOULD PUT STATUS FOR PARAMS

        return nil
    end 

    def self.find(id)
        query = 'SELECT * FROM bookings WHERE id = $1;'
        result = DatabaseConnection.exec_params(query, [id])

      return find_helper(result)
    end

    def self.all
        bookings = []
        query = 'SELECT * FROM bookings;'
        result = DatabaseConnection.exec_params(query, [])
        result.each do |inst|
          bookings << all_helper(inst)
        end
        return bookings
      end 

    def self.update(booking)
        query = "UPDATE bookings SET space_id = $1, user_id = $2, start_date = $3, end_date = $4, contents = $5, status = $6"
        params = [booking.space_id, booking.user_id, booking.start_date, booking.end_date, booking.contents, booking.status]
        result = DatabaseConnection.exec_params(query, params)

        return nil
    end 

    def self.delete(id)
        query = "DELETE FROM bookings WHERE id = $1"
        result = DatabaseConnection.exec_params(query, [id])
  
        return nil
    end

    def self.booked_dates(space_id, start_date, end_date)
      availability = DatabaseConnection.exec_params('SELECT start_date, end_date FROM spaces WHERE id = $1', [space_id]).first
  
      space_start_date = Date.parse(availability['start_date'])
      space_end_date = Date.parse(availability['end_date'])
  
      # Determine the booked dates by finding the intersection between the availability dates and the booking dates
      booked_dates = (space_start_date..space_end_date).to_a & (start_date..end_date).to_a
  
      booked_dates
    end
      
    private

    def self.all_helper(inst)
        booking = Booking.new 
        booking.id = inst['id'].to_i
        booking.space_id = inst['space_id'].to_i
        booking.user_id = inst['user_id'].to_i
        booking.start_date = inst['start_date']
        booking.end_date = inst['end_date']
        booking.contents = inst['contents']
        booking.status = inst['status']

        return booking
    end 

    def self.find_helper(result)
        return nil if result.ntuples.zero?
        booking = Booking.new 
        booking.id = result[0]['id'].to_i
        booking.space_id = result[0]['space_id'].to_i
        booking.user_id = result[0]['user_id'].to_i
        booking.start_date = result[0]['start_date']
        booking.end_date = result[0]['end_date']
        booking.contents = result[0]['contents']
        booking.status = result[0]['status']

        return booking
    end 
end