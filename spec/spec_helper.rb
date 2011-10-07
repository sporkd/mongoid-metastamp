require "rubygems"
require "bundler/setup"

require "rspec"

require "mongoid"
require "mongoid/metastamp"

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("mongoid_metastamp_test")
end

Dir["#{File.dirname(__FILE__)}/models/*.rb"].each { |f| require f }

RSpec.configure do |c|
  c.before(:each) do
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:remove)
  end
end
