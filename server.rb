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
  content_type :json
  
  body = {}  
  params.each do |key, value|
    body[key.lower_camelcase.gsub(/Id$/, 'ID')] = value unless key == :action
  end
  
  action = "get_#{params[:action]}".gsub(/id$/, 'iD')
    
  response = client.request :wsdl, action do
    soap.body = body
  end
  hash = response.to_hash
  hash = hash[hash.keys.first]
  hash.delete :@xmlns
  hash[hash.keys.first].to_json  
end