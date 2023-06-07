class Photo
  attr_accessor :id, :space_id, :photo_url

  def initialize(id, space_id, photo_url)
    @id = id
    @space_id = space_id
    @photo_url = photo_url
  end
end