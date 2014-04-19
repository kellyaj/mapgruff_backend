require 'sinatra'

class MapGruffBackend < Sinatra::Base
  get '/' do
    "hello"
  end
end

MapGruffBackend.run!
