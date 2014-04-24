require './dmconfig'
class IncidentCreator

  def self.create_incident(incident_hash)
    incident = Incident.create(incident_hash)
  end
end
