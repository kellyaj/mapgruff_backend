require 'spec_helper'
require 'app'
require 'rack/test'

describe 'MapGruffBackend' do
  include Rack::Test::Methods

  def app
    MapGruffBackend
  end

  before(:each) do
    @chicago_incident = {"city" => "Chicago IL", "primary_type" => "Theft", "local_identifier" => "some_number"}
    another_chicago_incident = {"city" => "Chicago IL", "primary_type" => "Theft", "local_identifier" => "some_other_chicago_number"}
    @seattle_incident = {"city" => "Seattle WA", "primary_type" => "Burglary", "local_identifier" => "some_other_number"}

    Incident.create(@chicago_incident)
    Incident.create(another_chicago_incident)
    Incident.create(@seattle_incident)
  end

  it "returns all chicago incidents" do
    get '/all_chicago'
    incidents = JSON.parse(last_response.body)

    last_response.should be_ok
    incidents.count.should == 2

    first_found_incident = incidents.first
    first_found_incident["city"].should == @chicago_incident["city"]
    first_found_incident["primary_type"].should == @chicago_incident["primary_type"]
    first_found_incident["local_identifier"].should == @chicago_incident["local_identifier"]
  end

  it "returns all seattle incidents" do
    get '/all_seattle'
    incidents = JSON.parse(last_response.body)

    last_response.should be_ok
    incidents.count.should == 1

    first_found_incident = incidents.first
    first_found_incident["city"].should == @seattle_incident["city"]
    first_found_incident["primary_type"].should == @seattle_incident["primary_type"]
    first_found_incident["local_identifier"].should == @seattle_incident["local_identifier"]
  end
end
