require './lib/incident_monger'
require './lib/incident_creator'

task :gather_incidents do
  p "making request for Chicago incidents..."
  chicago_incidents = IncidentMonger.fetch_chicago_incidents
  p "making request for Seattle incidents..."
  seattle_incidents = IncidentMonger.fetch_seattle_incidents
  IncidentCreator.create_incidents(chicago_incidents)
  IncidentCreator.create_incidents(seattle_incidents)
end

task :assign_locations do
  IncidentMonger.assign_locations
end

task :incident_count do
  p IncidentMonger.count_incidents
end

task :backfill_categories do
  all_incidents = Incident.all

  all_incidents.each do |incident|
    if incident.category.nil?
      incident.category = IncidentMonger.get_category(incident.city, incident.primary_type)
      incident.save
    end
  end
end
