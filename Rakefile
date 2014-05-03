require './lib/incident_monger'
require './lib/incident_creator'

task :gather_incidents do
  chicago_incidents = IncidentMonger.fetch_chicago_incidents
  seattle_incidents = IncidentMonger.fetch_seattle_incidents
  IncidentCreator.create_chicago_incidents(chicago_incidents)
  IncidentCreator.create_chicago_incidents(seattle_incidents)
end

task :assign_locations do
  IncidentMonger.assign_locations
end
