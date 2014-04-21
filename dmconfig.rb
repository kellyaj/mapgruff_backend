require 'dm-core'
require 'dm-migrations'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "root:@localhost/mapgruff")
DataMapper.finalize
DataMapper.auto_upgrade!
