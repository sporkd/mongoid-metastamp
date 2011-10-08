# encoding: utf-8

module Mongoid #:nodoc:
  module Metastamp
    class Time
      include Mongoid::Fields::Serializable
      include Mongoid::Fields::Serializable::Timekeeping

      def deserialize(object)
        return nil if object.blank?
        super(object[:in_zone])
      end

      def serialize(object)
        time = super(object)
        normalized_time = normalize_time(object)
        { 
          in_zone:      time,
          normalized:   normalized_time,
          year:         normalized_time.year,
          month:        normalized_time.month,
          day:          normalized_time.day,
          hour:         normalized_time.hour,
          min:          normalized_time.min,
          sec:          normalized_time.sec
        }
      end

    protected

      def normalize_time(object)
        case object
          when ::String
            time = ::Time.parse(object)
          when ::DateTime
            time = ::Time.new(object.year, object.month, object.day, object.hour, object.min, object.sec)
          when ::Date
            time = ::Time.new(object.year, object.month, object.day)
          when ::Array
            time = ::Time.new(*object)
          else
            time = object
        end
        ::Time.parse(time.iso8601.sub(/-(\d\d:\d\d)$/, "-00:00"))
      end
    end
  end
end