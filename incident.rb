class Incident
  include DataMapper::Resource

  property :id,                   Serial
  property :primary_type,         String
  property :latitude,             String
  property :longitude,            String
  property :description,          String
  property :incident_date,        String
  property :location_icon,        String
  property :location_description, String
  property :arrest_status,        String
end
