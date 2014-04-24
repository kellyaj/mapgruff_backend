require 'data_mapper'
require './incident'

#DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://root:@localhost/mapgruff')
DataMapper.finalize
DataMapper.auto_upgrade!
