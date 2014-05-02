require 'httparty'
require 'json'

class IncidentMonger

  def self.standardize_incidents(city_config, parsed_incidents)
    parsed_incidents.inject([]) do |acc, incident|
      # TODO: instead of 0, hit geocoding to determine lat/long based on address
      acc << {
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
  end

  API_KEY = ""

  def self.make_geocode_request(address, city_string)
    base_url = "https://maps.googleapis.com/maps/api/geocode/json?"
    address_string = "address=" + self.format_geocodable_address(address, city_string)
    request_suffix = "&sensor=false&key=#{API_KEY}"
    full_request_url = base_url + address_string + request_suffix
    response = HTTParty.get(full_request_url)
    JSON.parse(response.body)
  end

  def self.format_geocodable_address(raw_address, city)
    stripped_address = (raw_address.sub /0+/, '').gsub(/X/){ |s| '0' }
    combined_address = stripped_address + " " + city.upcase
    combined_address.gsub(/ /){ |s| '+' }
  end

  def self.fetch_chicago_incidents
    # TODO: generalize this to consume configs for different URLs
    # need to figure out how were going to query this shit
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
