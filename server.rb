require 'json'
require 'sinatra'
require 'sass'
require './lib/openligadb'

liga = OpenLigaDB.new

set :haml, :format => :html5

get '/' do
  haml :index
end

get '/api/:action' do |action|
  content_type :json
  params.delete :action

  liga.request(action, params).to_json
end

get '/stylesheet.css' do
  sass :stylesheet
end