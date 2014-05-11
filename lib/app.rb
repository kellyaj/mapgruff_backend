require 'sinatra'
require 'json'
require './dmconfig'


class MapGruffBackend < Sinatra::Base
  get '/all_chicago' do
    chicago_incidents = Incident.all(:city => "Chicago IL")
    chicago_incidents.to_json
  end

  get '/all_seattle' do
    seattle_incidents = Incident.all(:city => "Seattle WA")
    seattle_incidents.to_json
  end
end
