#encoding: utf-8

require "spec_helper"

describe "Mongoid::Metastamp::Time" do

  before :each do
    Zonebie.set_random_timezone
  end

  context "when storing nil" do

    context "on initialization" do

      let :event do
        Event.new(timestamp: nil)
      end

      describe "on serialization" do

        it "should store timestamp as nil" do
          event['timestamp'].should == nil
        end

      end

      describe "on deserialization" do

        it "timestamp should return nil" do
          event.timestamp.should == nil
        end

      end

    end

    context "on creation" do

      let :event do
        Event.create(timestamp: nil).reload
      end

      describe "on serialization" do

        it "should store timestamp as nil" do
          event['timestamp'].should == nil
        end

      end

      describe "on deserialization" do

        it "timestamp should return nil" do
          event.timestamp.should == nil
        end

      end

    end

  end

  [0, 12, 23].each do |hour|

    [Date.today, (Date.today + 6.months)].each do |date|

      context "storing a timestamp created on #{ date } at #{ hour }:00" do
        
        {
          "Time"        => :to_time,
          "String"      => :to_s,
          "iso8601"     => :iso8601,
          "DateTime"    => :to_datetime
        }.each do |format, method|

          context "formatted as a #{ format }" do

            let! :time do
              Time.zone.parse("#{date.to_s} #{hour}:00:00")
            end

            let! :normalized do
              Time.parse("#{date.to_s} #{hour}:00:00 -0000")
            end

            let! :timestamp do
              method ? time.send(method) : time
            end

            context "on initialization" do

              let :event do
                Event.new(timestamp: timestamp)
              end

              describe "on serialization" do

                it "should store timestamp.time" do
                  event['timestamp']['time'].should == time
                end

                it "should store timestamp.normalized" do
                  event['timestamp']['normalized'].should == normalized
                end

                it "should store timestamp.year as #{ date.year }" do
                  event['timestamp']['year'].should == date.year
                end

                it "should store timestamp.month as #{ date.month }" do
                  event['timestamp']['month'].should == date.month
                end

                it "should store timestamp.day as #{ date.day }" do
                  event['timestamp']['day'].should == date.day
                end

                it "should store timestamp.wday as #{ date.wday }" do
                  event['timestamp']['wday'].should == date.wday
                end

                it "should store timestamp.hour as #{ hour }" do
                  event['timestamp']['hour'].should == hour
                end

                it "should store timestamp.min as 0" do
                  event['timestamp']['min'].should == 0
                end

                it "should store timestamp.sec as 0" do
                  event['timestamp']['sec'].should == 0
                end

                it "should store timestamp.zone at Time.zone.name" do
                  event['timestamp']['zone'].should == Time.zone.name
                end

                it "should store timestamp.offset" do
                  event['timestamp']['offset'].should == time.utc_offset
                end

              end

              describe "on deserialization" do

                it "timestamp should return the original time" do
                  # Time.zone = "UTC"
                  event.timestamp.should == time
                end

                it "timestamp should return time in local time" do
                  # Time.zone = "UTC"
                  event.timestamp.utc_offset.should == time.utc_offset
                end

              end

              describe "copying a timestamp" do

                let :event2 do
                  Event.new(timestamp: event.timestamp)
                end

                it "both timestamps should be the same" do
                  event2['timestamp'].should == event['timestamp']
                end

              end

            end

            context "on creation" do

              let :event do
                Event.create(timestamp: timestamp).reload
              end

              describe "on serialization" do

                it "should store timestamp.time" do
                  event['timestamp']['time'].should == time
                end

                it "should store timestamp.normalized" do
                  event['timestamp']['normalized'].should == normalized
                end

                it "should store timestamp.year as #{ date.year }" do
                  event['timestamp']['year'].should == date.year
                end

                it "should store timestamp.month as #{ date.month }" do
                  event['timestamp']['month'].should == date.month
                end

                it "should store timestamp.day as #{ date.day }" do
                  event['timestamp']['day'].should == date.day
                end

                it "should store timestamp.wday as #{ date.wday }" do
                  event['timestamp']['wday'].should == date.wday
                end

                it "should store timestamp.hour as #{ hour }" do
                  event['timestamp']['hour'].should == hour
                end

                it "should store timestamp.min as 0" do
                  event['timestamp']['min'].should == 0
                end

                it "should store timestamp.sec as 0" do
                  event['timestamp']['sec'].should == 0
                end

                it "should store timestamp.zone at Time.zone.name" do
                  event['timestamp']['zone'].should == Time.zone.name
                end

                it "should store timestamp.offset" do
                  event['timestamp']['offset'].should == time.utc_offset
                end

              end

              describe "on deserialization" do

                it "timestamp should return the original time" do
                  # Time.zone = "UTC"
                  event.timestamp.should == time
                end

                it "timestamp should return time in local time" do
                  # Time.zone = "UTC"
                  event.timestamp.utc_offset.should == time.utc_offset
                end

              end

              describe "copying a timestamp" do

                let :event2 do
                  Event.create(timestamp: event.timestamp)
                end

                it "both timestamps should be the same" do
                  event2['timestamp'].should == event['timestamp']
                end

              end

            end

          end

        end

      end

    end

  end

end