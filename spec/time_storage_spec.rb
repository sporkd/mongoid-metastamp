#encoding: utf-8

require "spec_helper"

describe "Mongoid::Metastamp::Time" do

  [0, 12, 23].each do |hour|

    ["+00:00", "-04:00", "-07:00", "+13:00"].each do |zone|

      time_utc = Time.new(2011, 12, 31, hour, 0, 0, '-00:00')
      time = Time.new(2011, 12, 31, hour, 0, 0, zone)

      context "storing time #{ time }" do
        
        {
          "String"      => time.to_s,
          "iso8601"     => time.iso8601,
          "Time"        => time
        }.each do |format, timestamp|

          context "formatted as #{ format } (#{ timestamp })" do

            context "on initialization" do

              let :event do
                Event.new(timestamp: timestamp)
              end

              describe "on serialization" do

                it "should store timestamp.time" do
                  event['timestamp']['time'].should == time
                end

                it "should store timestamp.normalized" do
                  event['timestamp']['normalized'].should == time_utc
                end

                it "should store timestamp.year as 2011" do
                  event['timestamp']['year'].should == 2011
                end

                it "should store timestamp.month as 12" do
                  event['timestamp']['month'].should == 12
                end

                it "should store timestamp.day as 31" do
                  event['timestamp']['day'].should == 31
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

                it "should store timestamp.zone as #{ zone }" do
                  event['timestamp']['zone'].should == zone
                end

                it "should store timestamp.offset as #{ (zone.to_i * 60 * 60) }" do
                  event['timestamp']['offset'].should == (zone.to_i * 60 * 60)
                end

              end

              describe "on deserialization" do

                it "timestamp should return #{ time }" do
                  event.timestamp.should == time
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
                  event['timestamp']['normalized'].should == time_utc
                end

                it "should store timestamp.year as 2011" do
                  event['timestamp']['year'].should == 2011
                end

                it "should store timestamp.month as 12" do
                  event['timestamp']['month'].should == 12
                end

                it "should store timestamp.day as 31" do
                  event['timestamp']['day'].should == 31
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

                it "should store timestamp.zone as #{ zone }" do
                  event['timestamp']['zone'].should == zone
                end

                it "should store timestamp.offset as #{ (zone.to_i * 60 * 60) }" do
                  event['timestamp']['offset'].should == (zone.to_i * 60 * 60)
                end

              end

              describe "on deserialization" do

                it "timestamp should return #{ time }" do
                  event.timestamp.should == time
                end

              end

            end

          end

        end

      end

    end

  end

end