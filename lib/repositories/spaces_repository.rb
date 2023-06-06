require_relative '../models/space'
class SpacesRepository
    def self.create(name, city, description, price, start_date, end_date, user_id)
        query = "INSERT INTO spaces (name, city, description, price, start_date, end_date, created_at, updated_at, user_id) VALUES ($1, $2, $3, $4, $5, $6, NOW(), NOW(), $7);"
        DatabaseConnection.exec_params(query, [name, city, description, price, start_date, end_date, user_id])
    
        return nil
    end

    def self.all
      spaces = []
      query = "SELECT * FROM spaces;"
      result = DatabaseConnection.exec_params(query, [])
      result.each do |inst|
        spaces << all_helper(inst)
      end
      return spaces
    end 

    def self.find(id)
      query = "SELECT * FROM spaces WHERE id = $1;"
      result = DatabaseConnection.exec_params(query, [id])

      return find_helper(result)
    end

    def self.update(spaces)
      query = "UPDATE spaces SET name = $1, city = $2, description = $3, price = $4, start_date = $5, end_date = $6, updated_at = NOW() WHERE id = $7;"
      params = [spaces.name, spaces.city, spaces.description, spaces.price, spaces.start_date, spaces.end_date, spaces.id]
      result = DatabaseConnection.exec_params(query, params)

      return nil
    end

    def self.delete(id)
      query = "DELETE FROM spaces WHERE id = $1"
      result = DatabaseConnection.exec_params(query, [id])

      return nil
    end

    private

  def self.all_helper(inst)
    space = Space.new
    space.id = inst['id'].to_i
    space.name = inst['name']
    space.city = inst['city']
    space.description = inst['description']
    space.price = inst['price']
    space.start_date = inst['start_date']
    space.end_date = inst['end_date']
    space.user_id = inst['user_id']
    space.created_at = inst['created_at'] 
    space.updated_at = inst['updated_at']

    return space
  end

  def self.find_helper(result)
    return nil if result.ntuples.zero?
    space = Space.new
    space.id = result[0]['id'].to_i
    space.name = result[0]['name']
    space.city = result[0]['city']
    space.description = result[0]['descripttion']
    space.price = result[0]['price']
    space.start_date = result[0]['start_date']
    space.end_date = result[0]['end_date']
    space.user_id = result[0]['user_id']
    space.created_at = result[0]['created_at'] 
    space.updated_at = result[0]['updated_at']
    
    return space
  end


end