require_relative '../models/booking'

class BookingRepository 

    def self.create(space_id, user_id, start_date, end_date, contents, status = 'pending')
        query = 'INSERT INTO bookings (space_id, user_id, start_date, end_date, contents, status) VALUES ($1, $2, $3, $4, $5, $6);'
        DatabaseConnection.exec_params(query, [space_id, user_id, start_date, end_date, contents, status])
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
      
    private

    def self.all_helper(inst)
        booking = Booking.new 
        booking.space_id = inst['space_id'].to_i
        booking.user_id = inst['user_id']
        booking.start_date = inst['start_date']
        booking.end_date = inst['end_date']
        booking.contents = inst['contents']
        booking.status = inst['status']

        return booking
    end 

    def self.find_helper(result)
        return nil if result.ntuples.zero?
        booking = Booking.new 
        booking.space_id = result[0]['space_id'].to_i
        booking.user_id = result[0]['user_id']
        booking.start_date = result[0]['start_date']
        booking.end_date = result[0]['end_date']
        booking.contents = result[0]['contents']
        booking.status = result[0]['status']

        return booking
    end 
end