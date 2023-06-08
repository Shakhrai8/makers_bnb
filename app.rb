require 'sinatra/base'
require 'sinatra/reloader'
require 'dotenv/load'
require_relative 'lib/database_connection'
require_relative 'routes/users'
require_relative 'routes/spaces'
require_relative 'config'
require_relative 'routes/bookings'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/repositories/user_repository'
  end

  configure do
    enable :sessions
    set :session_secret, "5cdde102f6f68294e1cff23f341aaaaf2d2725453eaccc8ebc239629e724fc53"
  end

  use Users
  use Spaces
  
  get '/' do
    return erb(:index)
  end

  get '/about' do
    return erb(:about)
  end
end