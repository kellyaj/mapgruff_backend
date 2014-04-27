class IncidentMonger

  def self.standardize!(city_config, parsed_incidents)
    standardized_incidents = []
    parsed_incidents.each do |incident|
      standardized_incidents << {
        "primary_type"         => incident.fetch(city_config["primary_type"]),
        "latitude"             => incident.fetch(city_config["latitude"]),
        "longitude"            => incident.fetch(city_config["longitude"]),
        "date"                 => incident.fetch(city_config["date"]),
        "local_identifier"     => incident.fetch(city_config["local_identifier"]),
        "description"          => incident.fetch(city_config["description"]),
        "location_description" => incident.fetch(city_config["location_description"]),
        "city"                 => city_config["city"]
      }
    end
    standardized_incidents
  end
end
