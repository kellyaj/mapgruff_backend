require 'spec_helper'

describe IncidentCreator do
  it "creates fresh incidents" do
    raw_incident = {"city" => "Seattle", "primary_type" => "Theft", "local_identifier" => "some_number"}
    another_raw_incident = {"city" => "Seattle", "primary_type" => "Burglary", "local_identifier" => "some_other_number"}
    IncidentCreator.create_incidents([raw_incident, another_raw_incident])

    Incident.all.count.should == 2
  end

  it "does not create duplicate incidents" do
    raw_incident = {"city" => "Seattle", "primary_type" => "Theft", "local_identifier" => "some_number"}
    IncidentCreator.create_incidents([raw_incident])
    IncidentCreator.create_incidents([raw_incident])

    Incident.all.count.should == 1
  end
end
