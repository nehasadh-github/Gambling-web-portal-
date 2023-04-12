require 'dm-core'
require 'dm-migrations'

#DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/user.db")

DataMapper::setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/user.db")


DataMapper.finalize.auto_upgrade!

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/user.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

class User
  include DataMapper::Resource
  property :id, Serial
  property :username, String
  property :password, String
  property :totalwin, Integer
  property :totalloss, Integer
  property :totalprofit, Integer
end

DataMapper.finalize
