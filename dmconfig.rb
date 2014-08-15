require 'data_mapper'
require 'yaml'
require_relative './incident'

begin
  DB_STRING = YAML.load_file('/home/akells/sandbox/mapgruff_backend/config/db_setup.yml')
rescue
  DB_STRING = YAML.load_file('config/db_setup.yml')
end

#DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, DB_STRING)
DataMapper.finalize
DataMapper.auto_upgrade!
