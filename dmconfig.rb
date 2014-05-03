require 'data_mapper'
require 'yaml'
require './incident'

DB_STRING = YAML.load_file('config/db_setup.yml')

#DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, DB_STRING)
DataMapper.finalize
DataMapper.auto_upgrade!
