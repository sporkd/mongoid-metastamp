require "rubygems"
require "bundler/setup"
require "zonebie"

require "mongoid"
require "mongoid/metastamp"
require "mongoid/metastamp/time"

require "rspec"

Zonebie.set_random_timezone

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("mongoid_metastamp_test")
  config.use_utc = false
  config.use_activesupport_time_zone = true
end

Dir["#{File.dirname(__FILE__)}/models/*.rb"].each { |f| require f }

RSpec.configure do |c|
  c.before :all do
    Zonebie.set_random_timezone
  end

  c.before :each do
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:remove)
  end
end
