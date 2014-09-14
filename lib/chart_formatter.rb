require './dmconfig'

class ChartFormatter

  def self.create_chart_data(city_name)
    incidents = Incident.all(:city => city_name)
    acc = []
    ["VIOLENT", "PROPERTY", "PERSONAL", "OTHER"].each do |category|
      count = incidents.all(:category => category).count
      acc << {
        "value" => count,
        "color" => get_color(category),
        "highlight" => get_highlight(category),
        "label" => category
      }
    end
    acc
  end

  def self.get_color(category)
    case category
    when "VIOLENT"
      "#F7464A"
    when "PROPERTY"
      "#3366FF"
    when "PERSONAL"
      "#FDB45C"
    when "OTHER"
      "#46BFBD"
    end
  end

  def self.get_highlight(category)
    case category
    when "VIOLENT"
      "#FF5A5E"
    when "PROPERTY"
      "#7094FF"
    when "PERSONAL"
      "#FFC870"
    when "OTHER"
      "#5AD3D1"
    end
  end
end
