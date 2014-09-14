require 'spec_helper'

describe ChartFormatter do
  it "formats data for chart consumption" do
      Incident.create({
        "city" => "Seattle WA",
        "category" => "PROPERTY"
      })
      Incident.create({
        "city" => "Seattle WA",
        "category" => "PROPERTY"
      })
      Incident.create({
        "city" => "Seattle WA",
        "category" => "VIOLENT"
      })
      Incident.create({
        "city" => "Seattle WA",
        "category" => "PERSONAL"
      })
      Incident.create({
        "city" => "Seattle WA",
        "category" => "OTHER"
      })
      Incident.create({
        "city" => "Seattle WA",
        "category" => "OTHER"
      })
      Incident.create({
        "city" => "Seattle WA",
        "category" => "OTHER"
      })

      chart_data = ChartFormatter.create_chart_data("Seattle WA")
      violent_data = chart_data.detect { |b| b["label"] == "VIOLENT" }
      property_data = chart_data.detect { |b| b["label"] == "PROPERTY" }
      personal_data = chart_data.detect { |b| b["label"] == "PERSONAL" }
      other_data = chart_data.detect { |b| b["label"] == "OTHER" }

      violent_data.should == {"value" => 1, "color" => "#F7464A", "highlight" => "#FF5A5E", "label" => "VIOLENT"}
      property_data.should == {"value" => 2, "color" => "#3366FF", "highlight" => "#7094FF", "label" => "PROPERTY"}
      personal_data.should == {"value" => 1, "color" => "#FDB45C", "highlight" => "#FFC870", "label" => "PERSONAL"}
      other_data.should == {"value" => 3, "color" => "#46BFBD", "highlight" => "#5AD3D1", "label" => "OTHER"}
  end
end
