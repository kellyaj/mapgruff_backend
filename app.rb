require 'sinatra'
require 'data_mapper'
require 'dm_mysql_adapter'


class MapGruffBackend < Sinatra::Base
  get '/' do
    "hello"
  end
end

MapGruffBackend.run!
