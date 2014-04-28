require 'httparty'
require 'json'

class IncidentMonger

  def self.standardize_incidents(city_config, parsed_incidents)
    standardized_incidents = []
    parsed_incidents.each do |incident|
      # TODO: instead of 0, hit geocoding to determine lat/long based on address
      standardized_incidents << {
        "primary_type"         => incident.fetch(city_config["primary_type"]),
        "latitude"             => incident.fetch(city_config["latitude"], 0),
        "longitude"            => incident.fetch(city_config["longitude"], 0),
        "date"                 => incident.fetch(city_config["date"]),
        "local_identifier"     => incident.fetch(city_config["local_identifier"]),
        "description"          => incident.fetch(city_config["description"]),
        "location_description" => incident.fetch(city_config["location_description"]),
        "city"                 => city_config["city"]
      }
    end
    standardized_incidents
  end

  def self.fetch_chicago_incidents
    raw_incidents = HTTParty.get("https://data.cityofchicago.org/resource/qnmj-8ku6.json?$limit=1000&$offset=0")
    parsed_incidents = JSON.parse(raw_incidents.body)
    standard_incidents = self.standardize_incidents(self.chicago_config, parsed_incidents)
  end

  def self.chicago_config
    {
      "primary_type"         => "primary_type",
      "latitude"             => "latitude",
      "longitude"            => "longitude",
      "date"                 => "date",
      "local_identifier"     => "case_number",
      "description"          => "description",
      "location_description" => "location_description",
      "city"                 => "Chicago"
    }
  end

  def self.seattle_config
    {
      "primary_type"         => "summarized_offense_description",
      "latitude"             => "latitude",
      "longitude"            => "longitude",
      "date"                 => "occurred_date_or_date_range_start",
      "local_identifier"     => "general_offense_number",
      "location_description" => "hundred_block_location",
      "description"          => "offense_type",
      "city"                 => "Seattle"
    }
  end
end
