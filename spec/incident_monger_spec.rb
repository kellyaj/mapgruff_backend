require 'spec_helper'

describe IncidentMonger do

  context "Standardizing Incidents" do
    before(:each) do
      @chicago_incidents = [
        {
          "case_number" => "something",
          "primary_type" => "Theft",
          "location_description" => "Residence",
          "date" => "2014-04-20T05:00:00",
          "description" => "Stolen Property",
          "longitude" => "-87.75369376707333",
          "latitude" => "41.880156392500034"
        },
        {
          "case_number" => "something_else",
          "primary_type" => "Theft",
          "location_description" => "Apartment",
          "date" => "2014-04-21T05:00:00",
          "description" => "Auto theft",
          "longitude" => "-87.75369376707333",
          "latitude" => "41.880156392500034"
        }
      ]
    end

    it 'converts Chicago response data into properly formatted data' do
      standardized_incidents = IncidentMonger.standardize_incidents(IncidentMonger.chicago_config, @chicago_incidents)

      standardized_incidents.count.should == 2
      standardized_incidents.first["primary_type"].should == "Theft"
      standardized_incidents.first["local_identifier"].should == "something"
      standardized_incidents.first["city"].should == "Chicago IL"
      standardized_incidents.first["description"].should == "Stolen Property"
      standardized_incidents.first["date"].should == "2014-04-20T05:00:00"
    end

    it "selects OTHER category for unknown primary type" do
      other_crime = IncidentMonger.get_category("Chicago IL", "SOMETHING WEIRD")
      other_crime.should == "OTHER"
    end

    it 'sets a Chicago category based on the primary type' do
      property_crime = IncidentMonger.get_category("Chicago IL", "BURGLARY")
      personal_crime = IncidentMonger.get_category("Chicago IL", "STALKING")
      violent_crime = IncidentMonger.get_category("Chicago IL", "ASSAULT")
      other_crime = IncidentMonger.get_category("Chicago IL", "NARCOTICS")

      property_crime.should == "PROPERTY"
      personal_crime.should == "PERSONAL"
      violent_crime.should == "VIOLENT"
      other_crime.should == "OTHER"
    end

    it 'sets a Seattle category based on the primary type' do
      property_crime = IncidentMonger.get_category("Seattle WA", "PURSE SNATCH")
      personal_crime = IncidentMonger.get_category("Seattle WA", "THREATS")
      violent_crime = IncidentMonger.get_category("Seattle WA", "WEAPON")
      other_crime = IncidentMonger.get_category("Seattle WA", "TRAFFIC")

      property_crime.should == "PROPERTY"
      personal_crime.should == "PERSONAL"
      violent_crime.should == "VIOLENT"
      other_crime.should == "OTHER"
    end


    it 'converts Seattle response data into properly formatted data' do
      seattle_incidents = [
        {
          "general_offense_number" => "something",
          "summarized_offense_description" => "Assault",
          "hundred_block_location" => "5XX Olive Way",
          "occurred_date_or_date_range_start" => "2014-04-20T05:00:00",
          "offense_type" => "beatdown",
          "longitude" => "-87.75369376707333",
          "latitude" => "41.880156392500034"
        },
        {
          "general_offense_number" => "something_else",
          "summarized_offense_description" => "Theft",
          "hundred_block_location" => "5XX Olive Way",
          "occurred_date_or_date_range_start" => "2014-04-20T05:00:00",
          "offense_type" => "Stolen Property",
          "longitude" => "-87.75369376707333",
          "latitude" => "41.880156392500034"
        }
      ]

      standardized_incidents = IncidentMonger.standardize_incidents(IncidentMonger.seattle_config, seattle_incidents)

      standardized_incidents.count.should == 2
      standardized_incidents.first["primary_type"].should == "Assault"
      standardized_incidents.first["description"].should == "beatdown"
      standardized_incidents.first["date"].should == "2014-04-20T05:00:00"
      standardized_incidents.first["local_identifier"].should == "something"
      standardized_incidents.first["city"].should == "Seattle WA"
    end

    it 'uses geocoding to save lat/long data for incidents without lat/long' do
      Incident.create({
        "local_identifier" => "something_else",
        "primary_type" => "Theft",
        "block" => "025XX W 46TH ST",
        "location_description" => "Apartment",
        "date" => "2014-04-21T05:00:00",
        "description" => "Auto theft",
        "longitude" => "",
        "latitude" => "",
        "city" => "Chicago IL"
      })
      mocked_response = { "results" => [ "geometry" => { "location" => { "lat" => "1.2345", "lng" => "9.8765" } } ]
        }.to_json
      api_key = YAML.load_file('config/geocode_api.yml')
      stub_request(:any, "https://maps.googleapis.com/maps/api/geocode/json?address=2500%20W%2046TH%20ST%20CHICAGO%20IL&key=#{api_key}&sensor=false").to_return(:body => mocked_response, :status => 200, :headers => {})

      IncidentMonger.assign_locations

      Incident.first.latitude.should == "1.2345"
      Incident.first.longitude.should == "9.8765"
    end
  end

  context "Geocoding addresses" do
    it "converts a raw address into an approximated geocodable string" do
      raw_address = "007XX N HOMAN AVE"
      city = "Chicago IL"

      formatted_address = IncidentMonger.format_geocodable_address(raw_address, city)

      formatted_address.should == "700+N+HOMAN+AVE+CHICAGO+IL"
    end
  end
end
