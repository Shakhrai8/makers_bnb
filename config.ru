require_relative './app'
require 'rack'
use Rack::Static,
  urls: ['/assets'],
  root: 'public',
  index: 'index.html',
  header_rules: [
    [:all, { 'Content-Type' => 'application/javascript' }]
  ]

run Application