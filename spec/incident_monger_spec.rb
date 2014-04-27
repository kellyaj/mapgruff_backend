require 'incident_monger'
require 'spec_helper'

describe IncidentMonger do
  it 'converts Chicago response data into properly formatted data for Chicago' do
    chicago_incidents = [
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

    chicago_config = {
      "primary_type"         => "primary_type",
      "latitude"             => "latitude",
      "longitude"            => "longitude",
      "date"                 => "date",
      "local_identifier"     => "case_number",
      "description"          => "description",
      "location_description" => "location_description",
      "city"                 => "Chicago"
    }

    standardized_incidents = IncidentMonger.standardize!(chicago_config, chicago_incidents)

    standardized_incidents.count.should == 2
    standardized_incidents.first["primary_type"].should == "Theft"
    standardized_incidents.first["local_identifier"].should == "something"
    standardized_incidents.first["city"].should == "Chicago"
    standardized_incidents.first["description"].should == "Stolen Property"
    standardized_incidents.first["date"].should == "2014-04-20T05:00:00"
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
    seattle_config = {
      "primary_type"         => "summarized_offense_description",
      "latitude"             => "latitude",
      "longitude"            => "longitude",
      "date"                 => "occurred_date_or_date_range_start",
      "local_identifier"     => "general_offense_number",
      "location_description" => "hundred_block_location",
      "description"          => "offense_type",
      "city"                 => "Seattle"
    }

    standardized_incidents = IncidentMonger.standardize!(seattle_config, seattle_incidents)

    standardized_incidents.count.should == 2
    standardized_incidents.first["primary_type"].should == "Assault"
    standardized_incidents.first["description"].should == "beatdown"
    standardized_incidents.first["date"].should == "2014-04-20T05:00:00"
    standardized_incidents.first["local_identifier"].should == "something"
    standardized_incidents.first["city"].should == "Seattle"
  end
end
