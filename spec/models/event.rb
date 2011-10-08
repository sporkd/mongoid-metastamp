class Event
  include Mongoid::Document
  field :timestamp, type: Mongoid::Metastamp::Time
end
