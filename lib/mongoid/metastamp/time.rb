# encoding: utf-8

module Mongoid #:nodoc:
  module Metastamp
    class Time
      include Mongoid::Fields::Serializable
      include Mongoid::Fields::Serializable::Timekeeping
    end
  end
end