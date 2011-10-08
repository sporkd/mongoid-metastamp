# encoding: utf-8

module Mongoid #:nodoc:
  module Metastamp
    class Time
      include Mongoid::Fields::Serializable
      include Mongoid::Fields::Serializable::Timekeeping

      # def cast_on_read?; true; end

      def deserialize(object)
        return nil if object.blank?
        super(object[:time])
      end

      def serialize(object)
        time = super(object)
        universal_time = normalize_time(object)
        { 
          time:             time,
          year:             time.year,
          month:            time.month,
          day:              time.day,
          hour:             time.hour,
          min:              time.min,
          sec:              time.sec,
          universal_time:   universal_time,
          universal_year:   universal_time.year,
          universal_month:  universal_time.month,
          universal_day:    universal_time.day,
          universal_hour:   universal_time.hour
        }
      end

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