# config.rb

require 'dotenv/load'

module Config
  WEATHER_API_KEY = ENV['WEATHER_API_KEY']
end
