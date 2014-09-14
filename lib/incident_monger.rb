require 'httparty'
require 'json'
require 'yaml'

class IncidentMonger

  def self.standardize_incidents(city_config, parsed_incidents)
    parsed_incidents.inject([]) do |acc, incident|
      acc << {
        "primary_type"         => incident.fetch(city_config["primary_type"], ""),
        "latitude"             => incident.fetch(city_config["latitude"], ""),
        "longitude"            => incident.fetch(city_config["longitude"], ""),
        "date"                 => incident.fetch(city_config["date"], ""),
        "local_identifier"     => incident.fetch(city_config["local_identifier"], ""),
        "description"          => incident.fetch(city_config["description"], ""),
        "location_description" => incident.fetch(city_config["location_description"], ""),
        "block"                => incident.fetch(city_config["block"], ""),
        "city"                 => city_config["city"],
        "category"             => get_category(city_config["city"], incident.fetch(city_config["primary_type"]))
      }
    end
  end

  def self.get_category(city, primary_type)
    if city == "Chicago IL"
      category = chicago_categories.select { |k, v| v.include?(primary_type) }.keys.first
      category.nil? ? "OTHER" : category
    else
      category = seattle_categories.select { |k, v| v.include?(primary_type) }.keys.first
      category.nil? ? "OTHER" : category
    end
  end

  API_KEY = YAML.load_file('config/geocode_api.yml')

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

  def self.assign_locations
    unmapped_incidents = Incident.all(:latitude => "")
    unmapped_incidents.each do |incident|
      raw_location_data = self.make_geocode_request(incident.block, incident.city)["results"].first
      incident.latitude = raw_location_data["geometry"]["location"]["lat"]
      incident.longitude = raw_location_data["geometry"]["location"]["lng"]
      incident.save
    end
  end

  def self.fetch_chicago_incidents
    raw_incidents = HTTParty.get("https://data.cityofchicago.org/resource/ijzp-q8t2.json?$limit=1000&$offset=0")
    parsed_incidents = JSON.parse(raw_incidents.body)
    standard_incidents = self.standardize_incidents(self.chicago_config, parsed_incidents)
  end

  def self.fetch_seattle_incidents
    raw_incidents = HTTParty.get("https://data.seattle.gov/resource/7ais-f98f.json?$limit=1000&$offset=0&$order=occurred_date_or_date_range_start%20desc")
    p "parsing Seattle incidents..."
    parsed_incidents = JSON.parse(raw_incidents.body)
    p "standardizing Seattle incidents..."
    standard_incidents = self.standardize_incidents(self.seattle_config, parsed_incidents)
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
      "city"                 => "Chicago IL",
      "block"                => "block"
    }
  end

  def self.chicago_categories
    {
      "OTHER" => [
          "ARSON",
          "GAMBLING",
          "INTERFERENCE WITH PUBLIC OFFICE",
          "LIQUOR LAW VIOLATION",
          "NARCOTICS",
          "NON-CRIMINAL",
          "OFFENSE INVOLVING CHILDREN",
          "OTHER NARCOTIC VIOLATION",
          "OTHER OFFENSE",
          "PROSTITUTION",
          "PUBLIC PEACE VIOLATION",
          "WEAPONS VIOLATION"
      ],
      "PERSONAL" => [
        "DECEPTIVE PRACTICE",
        "INTIMIDATION",
        "OBSCENITY",
        "STALKING"
      ],
      "PROPERTY" => [
        "BURGLARY",
        "CRIMINAL DAMAGE",
        "CRIMINAL TRESPASS",
        "MOTOR VEHICLE THEFT",
        "ROBBERY",
        "THEFT"
      ],
      "VIOLENT" => [
        "ASSAULT",
        "BATTERY",
        "CRIM SEXUAL ASSAULT",
        "HOMICIDE",
        "KIDNAPPING",
        "SEX OFFENSE"
      ]
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
      "city"                 => "Seattle WA",
      "block"                => "hundred_block_location"
    }
  end

  def self.seattle_categories
    {
      "OTHER" => [
        "ANIMAL COMPLAINT",
        "COUNTERFEIT",
        "DUI",
        "ELUDING",
        "EMBEZZLE",
        "FALSE REPORT",
        "FIREWORK",
        "FORGERY",
        "FRAUD",
        "FRAUD AND FINANCIAL",
        "GAMBLE",
        "ILLEGAL DUMPING",
        "[INC - CASE DC USE ONLY]",
        "INJURY",
        "LIQUOR VIOLATION",
        "LOST PROPERTY",
        "MAIL THEFT",
        "NARCOTICS",
        "OBSTRUCT",
        "PROPERTY DAMAGE",
        "PROSTITUTION",
        "PUBLIC NUISANCE",
        "RECKLESS BURNING",
        "RECOVERED PROPERTY",
        "STAY OUT OF AREA DRUGS",
        "STAY OUT OF AREA PROSTITUTION",
        "THEFT OF SERVICES",
        "TRAFFIC",
        "TRESPASS",
        "VIOLATION OF COURT ORDER",
        "WARRANT ARREST",
      ],
      "PERSONAL" => [
        "BIAS INCIDENT",
        "DISORDERLY CONDUCT",
        "DISPUTE",
        "DISTURBANCE",
        "EXTORTION",
        "THREATS",
      ],
      "PROPERTY" => [
        "BIKE THEFT",
        "Bike Theft",
        "BURGLARY",
        "BURGLARY-SECURE-PARKING-RES",
        "CAR PROWL",
        "Car Prowl",
        "PURSE SNATCH",
        "Purse Snatch",
        "OTHER PROPERTY",
        "Other Property",
        "SHOPLIFTING",
        "Shoplifting",
        "STOLEN PROPERTY",
        "VEHICLE THEFT",
      ],
      "VIOLENT" => [
        "ASSAULT",
        "HOMICIDE",
        "ROBBERY",
        "WEAPON"
      ]
    }
  end

  def self.count_incidents
    Incident.all.count
  end
end
