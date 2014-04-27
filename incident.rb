class Incident
  include DataMapper::Resource

  property :id,                   Serial
  property :city,                 String
  property :primary_type,         String
  property :latitude,             String
  property :longitude,            String
  property :description,          String
  property :local_identifier,     String
  property :date,                 String
  property :location_icon,        String
  property :location_description, String
  property :arrest_status,        String

  validates_uniqueness_of :local_identifier
end
