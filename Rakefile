require 'httparty'
require 'json'

task :gather_incidents do
  raw_incidents = HTTParty.get("https://data.cityofchicago.org/resource/qnmj-8ku6.json?$limit=1000&$offset=0")
  JSON.parse(raw_incidents.body)
end
