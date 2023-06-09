require_relative '../models/photo'

class PhotoRepository
  def self.create(space_id, photo_url)
    query = "INSERT INTO photos (id, space_id, photo_url) VALUES ($1, $2);"
    DatabaseConnection.exec_params(query, [space_id, photo_url])

    return nil
  end

  def self.find_by_space_id(space_id)
    query = "SELECT * FROM photos WHERE space_id = $1;"
    result = DatabaseConnection.exec_params(query, [space_id])
    photos = []

    result.each do |row|
      photo = Photo.new(row['id'], row['space_id'], row['photo_url'])
      photos << photo
    end

    photos
  end

  def self.delete(photo_id)
    query = "DELETE FROM photos WHERE id = $1;"
    DatabaseConnection.exec_params(query, [photo_id])
  end
end
