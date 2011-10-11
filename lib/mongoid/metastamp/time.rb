# encoding: utf-8

module Mongoid #:nodoc:
  module Metastamp
    class Time
      include Mongoid::Fields::Serializable
      include Mongoid::Fields::Serializable::Timekeeping

      def deserialize(object)
        return nil if object.blank?
        return super(object) if object.instance_of?(::Time)
        super(object['time'])
      end

      def serialize(object)
        return nil if object.blank?
        time = super(object)
        date_time = parse_datetime(object)
        { 
          time:         time,
          normalized:   date_time.to_s.to_time,
          year:         date_time.year,
          month:        date_time.month,
          day:          date_time.day,
          wday:         date_time.wday,
          hour:         date_time.hour,
          min:          date_time.min,
          sec:          date_time.sec,
          zone:         date_time.zone,
          offset:       date_time.utc_offset
        }.stringify_keys
      end

    protected

      def parse_datetime(value)
        case value
          when ::String
            ::DateTime.parse(value)
          when ::Time
            offset = ActiveSupport::TimeZone.seconds_to_utc_offset(value.utc_offset)
            ::DateTime.new(value.year, value.month, value.day, value.hour, value.min, value.sec, offset)
          when ::Date
            ::DateTime.new(value.year, value.month, value.day)
          when ::Array
            ::DateTime.new(*value)
          else
            value
        end
      end
    end
  end
end