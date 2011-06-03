require 'savon'
require 'json'
require 'sinatra'
require 'pp'

set :haml, :format => :html5

get '/' do
  haml :index
end

client = Savon::Client.new "http://www.openligadb.de/Webservices/Sportsdata.asmx?wsdl"

get '/api/:action' do
  
  response = client.request :wsdl, params[:action] do
    soap.body = {}
    params.each do |key, value| 
      key = key.to_s.lower_camelcase.gsub(/Id$/, 'ID')
      soap.body[key] = value unless key == 'action'
    end
    pp soap.body
  end 

  content_type :json
  response.to_hash.to_json
end