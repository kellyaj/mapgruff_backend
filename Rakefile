require './lib/incident_monger'

task :gather_incidents do
  IncidentMonger.fetch_chicago_incidents
end

task :geocode do
  p IncidentMonger.make_geocode_request("007XX N HOMAN AVE", "Chicago IL")
end
