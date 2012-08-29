require 'json'
require 'sinatra'
require 'sass'
require 'statsmix'
require './lib/openligadb'

unless ENV['STATSMIX_URL']
  StatsMix.ignore = true
  StatsMix.api_key = ""
end

liga = OpenLigaDB.new

set :haml, :format => :html5

before do
  meta = {
    :ip => request.ip,
    :ua => request.user_agent,
    :params => params
  }
  if request.path == "/"
    StatsMix.track("/", 1, {:meta => meta})
  elsif request.path.start_with? "/api"
    StatsMix.track("/api", 1, {:meta => meta})
    StatsMix.track(request.path, 1, {:meta => meta})      
  end
end

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