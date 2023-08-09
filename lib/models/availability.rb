class Availability
  attr_accessor :id, :space_id, :date, :is_available

  def save
    if id.nil?
      DatabaseConnection.exec_params(
        "INSERT INTO availability (date, is_available) VALUES ($1, $2)",
        [date, is_available]
      )
    else
      DatabaseConnection.exec_params(
        "UPDATE availability SET date = $1, is_available = $2 WHERE id = $3",
        [date, is_available, id]
      )
    end
  end
end