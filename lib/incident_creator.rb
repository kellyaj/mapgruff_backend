require './dmconfig'
class IncidentCreator

  def self.create_chicago_incidents(incident_array)
    incident_array.each do |incident|
        Incident.create(incident)
    end
  end

end
