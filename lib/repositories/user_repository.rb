require_relative '../models/user'

class UserRepository
  def self.create(username, email, password)
    query = "INSERT INTO users (username, email, password) VALUES ($1, $2, $3);"
    DatabaseConnection.exec_params(query, [ username, email, password])

    return nil
  end

  def self.find(id)
    query = "SELECT id, username, email, password FROM users WHERE id = $1;"
    result = DatabaseConnection.exec_params(query, [id])

    return find_helper(result)
  end

  def self.authenticate(email, password)
    query = "SELECT id, username, email, password FROM users WHERE email = $1 AND password = $2;"
    result = DatabaseConnection.exec_params(query, [email, password])
    return nil if result.ntuples.zero?

    return find_helper(result)
  end

  def self.all
    users = []
    query = "SELECT id, username, email, password FROM users;"
    result = DatabaseConnection.exec_params(query, [])
    result.each do |inst|
      users << all_helper(inst)
    end
    return users
  end

  private

  def self.all_helper(inst)
    user = User.new
    user.id = inst['id'].to_i
    user.username = inst['username']
    user.email = inst['email']
    user.password = inst['password']

    return user
  end

  def self.find_helper(result)
    return nil if result.ntuples.zero?
    user = User.new
    user.id = result[0]['id'].to_i
    user.username = result[0]['username']
    user.email = result[0]['email']
    user.password = result[0]['password']

    return user
  end
end