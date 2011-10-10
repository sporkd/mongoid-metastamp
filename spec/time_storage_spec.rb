#encoding: utf-8

require "spec_helper"

describe "Mongoid::Metastamp::Time storage" do

  let :ten_am_utc do
    "2011-10-05T10:00:00-00:00"
  end

  let :ten_am_pacific do
    "2011-10-05T10:00:00-07:00"
  end

  context "initialized with a timestamp of 10 AM PST" do

    let :pst_event do
      Event.new(timestamp: ten_am_pacific)
    end

    describe "on serialization" do

      it "should store timestamp.in_zone" do
        pst_event['timestamp']['in_zone'].should == Time.parse(ten_am_pacific)
      end

      it "should store timestamp.normalized" do
        pst_event['timestamp']['normalized'].should == Time.parse(ten_am_utc)
      end

      it "should store timestamp.year" do
        pst_event['timestamp']['year'].should == 2011
      end

      it "should store timestamp.month" do
        pst_event['timestamp']['month'].should == 10
      end

      it "should store timestamp.day" do
        pst_event['timestamp']['day'].should == 5
      end

      it "should store timestamp.hour" do
        pst_event['timestamp']['hour'].should == 10
      end

      it "should store timestamp.min" do
        pst_event['timestamp']['min'].should == 0
      end

      it "should store timestamp.sec" do
        pst_event['timestamp']['sec'].should == 0
      end

    end

    describe "on deserialization" do

      it "timestamp should return 10 AM PST" do
        pst_event.timestamp.should == Time.parse(ten_am_pacific)
      end

    end

  end

  context "created with a timestamp of 10 AM PST" do

    let :pst_event do
      Event.create(timestamp: ten_am_pacific).reload
    end

    describe "on serialization" do

      it "should store timestamp.in_zone" do
        pst_event['timestamp']['in_zone'].should == Time.parse(ten_am_pacific)
      end

      it "should store timestamp.normalized" do
        pst_event['timestamp']['normalized'].should == Time.parse(ten_am_utc)
      end

      it "should store timestamp.year" do
        pst_event['timestamp']['year'].should == 2011
      end

      it "should store timestamp.month" do
        pst_event['timestamp']['month'].should == 10
      end

      it "should store timestamp.day" do
        pst_event['timestamp']['day'].should == 5
      end

      it "should store timestamp.hour" do
        pst_event['timestamp']['hour'].should == 10
      end

      it "should store timestamp.min" do
        pst_event['timestamp']['min'].should == 0
      end

      it "should store timestamp.sec" do
        pst_event['timestamp']['sec'].should == 0
      end

    end

    describe "on deserialization" do

      it "timestamp should return 10 AM PST" do
        pst_event.timestamp.should == Time.parse(ten_am_pacific)
      end

    end

  end

end