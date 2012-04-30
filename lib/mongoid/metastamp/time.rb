# encoding: utf-8

module Mongoid #:nodoc:
  module Metastamp
    class Time
      include Mongoid::Fields::Serializable
      include Mongoid::Fields::Internal::Timekeeping

      def deserialize(object)
        return nil if object.blank?
        return super(object) if object.instance_of?(::Time)
        #time = object['time'].getlocal unless Mongoid::Config.use_utc?
        #zone = ActiveSupport::TimeZone[object['zone']]
        #zone = ActiveSupport::TimeZone[object['offset']] if zone.nil?
        #time.in_time_zone(zone)
        super(object['time'])
      end

      def serialize(object)
        return nil if object.blank?
        time = super(object)
        local_time = time.in_time_zone(::Time.zone)
        { 
          time:         time,
          normalized:   normalized_time(local_time),
          year:         local_time.year,
          month:        local_time.month,
          day:          local_time.day,
          wday:         local_time.wday,
          hour:         local_time.hour,
          min:          local_time.min,
          sec:          local_time.sec,
          zone:         ::Time.zone.name,
          offset:       local_time.utc_offset
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

      def normalized_time(time)
        ::Time.parse("#{ time.strftime("%F %T") } -0000")
      end
    end
  end
end