class IncidentMonger

  def self.standardize!(city_config, parsed_incidents)
    standardized_incidents = []
    parsed_incidents.each do |incident|
      new_incident = {}
      new_incident["primary_type"]         = incident.fetch(city_config["primary_type"])
      new_incident["latitude"]             = incident.fetch(city_config["latitude"])
      new_incident["longitude"]            = incident.fetch(city_config["longitude"])
      new_incident["date"]                 = incident.fetch(city_config["date"])
      new_incident["local_identifier"]     = incident.fetch(city_config["local_identifier"])
      new_incident["description"]          = incident.fetch(city_config["description"])
      new_incident["location_description"] = incident.fetch(city_config["location_description"])
      new_incident["city"]                 = city_config["city"]
      standardized_incidents << new_incident
    end
    standardized_incidents
  end
end
