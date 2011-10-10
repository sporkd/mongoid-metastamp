#encoding: utf-8

require "spec_helper"

describe "Mongoid::Metastamp::Time storage" do

  let :ten_am_utc do
    "2011-10-05T10:00:00-00:00"
  end

  let :ten_am_eastern do
    "2011-10-05T10:00:00-04:00"
  end

  context "initialized with a timestamp of 10 AM ET" do

    let :eastern_event do
      Event.new(timestamp: ten_am_eastern)
    end

    describe "on serialization" do

      it "should store timestamp.time" do
        eastern_event['timestamp']['time'].should == Time.parse(ten_am_eastern)
      end

      it "should store timestamp.normalized" do
        eastern_event['timestamp']['normalized'].should == Time.parse(ten_am_utc)
      end

      it "should store timestamp.year" do
        eastern_event['timestamp']['year'].should == 2011
      end

      it "should store timestamp.month" do
        eastern_event['timestamp']['month'].should == 10
      end

      it "should store timestamp.day" do
        eastern_event['timestamp']['day'].should == 5
      end

      it "should store timestamp.hour" do
        eastern_event['timestamp']['hour'].should == 10
      end

      it "should store timestamp.min" do
        eastern_event['timestamp']['min'].should == 0
      end

      it "should store timestamp.sec" do
        eastern_event['timestamp']['sec'].should == 0
      end

    end

    describe "on deserialization" do

      it "timestamp should return 10 AM ET" do
        eastern_event.timestamp.should == Time.parse(ten_am_eastern)
      end

    end

  end

  context "created with a timestamp of 10 AM ET" do

    let :eastern_event do
      Event.create(timestamp: ten_am_eastern).reload
    end

    describe "on serialization" do

      it "should store timestamp.time" do
        eastern_event['timestamp']['time'].should == Time.parse(ten_am_eastern)
      end

      it "should store timestamp.normalized" do
        eastern_event['timestamp']['normalized'].should == Time.parse(ten_am_utc)
      end

      it "should store timestamp.year" do
        eastern_event['timestamp']['year'].should == 2011
      end

      it "should store timestamp.month" do
        eastern_event['timestamp']['month'].should == 10
      end

      it "should store timestamp.day" do
        eastern_event['timestamp']['day'].should == 5
      end

      it "should store timestamp.hour" do
        eastern_event['timestamp']['hour'].should == 10
      end

      it "should store timestamp.min" do
        eastern_event['timestamp']['min'].should == 0
      end

      it "should store timestamp.sec" do
        eastern_event['timestamp']['sec'].should == 0
      end

    end

    describe "on deserialization" do

      it "timestamp should return 10 AM ET" do
        eastern_event.timestamp.should == Time.parse(ten_am_eastern)
      end

    end

  end

end