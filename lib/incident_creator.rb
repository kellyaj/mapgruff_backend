require './dmconfig'
class IncidentCreator

  def self.create_chicago_incidents(incident_array)
    incident_array.each do |incident|
      incident = Incident.first(:local_identifier => incident["local_identifier"])
      if incident.nil?
        Incident.create(incident)
      end
    end
  end

end
