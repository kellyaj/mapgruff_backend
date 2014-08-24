require 'sinatra'
require 'json'
require './dmconfig'


class MapGruffBackend < Sinatra::Base
  get '/all_chicago' do
    response['Access-Control-Allow-Origin'] = "*"
    chicago_incidents = Incident.all(:city => "Chicago IL")
    chicago_incidents.to_json
  end

  get '/all_seattle' do
    response['Access-Control-Allow-Origin'] = "*"
    seattle_incidents = Incident.all(:city => "Seattle WA")
    seattle_incidents.to_json
  end

  get '/within_coords' do
    response['Access-Control-Allow-Origin'] = "*"
    incidents = Incident.all(
      :longitude.lte => params[:north_long],
      :longitude.gte => params[:south_long],
      :latitude.lte => params[:east_lat],
      :latitude.gte => params[:west_lat]
    )
    incidents.to_json
  end
end
