require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/repositories/UserRepository'
  end

  configure do
    enable :sessions
    set :session_secret, "5cdde102f6f68294e1cff23f341aaaaf2d2725453eaccc8ebc239629e724fc53"
  end

  get '/' do
    return erb(:index)
  end
end