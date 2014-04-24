require 'incident_creator'
require 'spec_helper'

describe IncidentCreator do
  it "creates an incident from a parsed hash" do
    raw_incident = {"city" => "Seattle", "primary_type" => "Theft"}
    IncidentCreator.create_incident(raw_incident)

    Incident.all.count.should == 1
    incident = Incident.first
    incident.city.should == "Seattle"
  end
end
