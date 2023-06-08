class Availability
  attr_accessor :id, :space_id, :date, :is_available

  def save
    # Assuming you have a database table called "availability"
    # and an ORM like ActiveRecord, you can save the object as follows:
    if id.nil?
      # Perform an INSERT operation to create a new record
      DatabaseConnection.exec_params(
        "INSERT INTO availability (date, is_available) VALUES ($1, $2)",
        [date, is_available]
      )
    else
      # Perform an UPDATE operation to update an existing record
      DatabaseConnection.exec_params(
        "UPDATE availability SET date = $1, is_available = $2 WHERE id = $3",
        [date, is_available, id]
      )
    end
  end
end