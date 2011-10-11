#encoding: utf-8

require "spec_helper"

describe "Mongoid::Metastamp::Time" do

  let :ten_am_utc do
    "2011-10-05T10:00:00-00:00"
  end

  let :ten_am_eastern do
    "2011-10-05T10:00:00-04:00"
  end

  let :ten_am_pacific do
    "2011-10-05T10:00:00-07:00"
  end

  context "given a 10:00 eastern and a 10:00 pacific timestamp" do

    before :each do
      @eastern_event = Event.create(timestamp: ten_am_eastern)
      @pacific_event = Event.create(timestamp: ten_am_pacific)
    end

    describe "searching by timestamp" do

      it "should not return any events when searching a 10:00 UTC range" do
        Event.where(
          :timestamp.gt => Time.parse(ten_am_utc) - 1.second,
          :timestamp.lt => Time.parse(ten_am_utc) + 1.second
        ).to_a.should == []
      end
          
      it "should only return the ET event when searching a 10:00 ET range" do
        Event.where(
          :timestamp.gt =>  Time.parse(ten_am_eastern) - 1.second,
          :timestamp.lt => Time.parse(ten_am_eastern) + 1.second
        ).to_a.should == [@eastern_event]
      end
    
      it "should only return the PT event when searching a 10:00 PT range" do
        Event.where(
          :timestamp.gt => Time.parse(ten_am_pacific) - 1.second,
          :timestamp.lt => Time.parse(ten_am_pacific) + 1.second
        ).to_a.should == [@pacific_event]
      end
    
    end

    describe "searching by timestamp.time" do

      it "should not return any events when searching a 10:00 UTC range" do
        Event.where(
          "timestamp.time" => {
            '$gt' => Time.parse(ten_am_utc) - 1.second,
            '$lt' => Time.parse(ten_am_utc) + 1.second
          }
        ).to_a.should == []
      end

      it "should only return the ET event when searching a 10:00 ET range" do
        Event.where(
          "timestamp.time" => {
            '$gt' => Time.parse(ten_am_eastern) - 1.second,
            '$lt' => Time.parse(ten_am_eastern) + 1.second
          }
        ).to_a.should == [@eastern_event]
      end

      it "should only return the PT event when searching a 10:00 PT range" do
        Event.where(
          "timestamp.time" => { 
            '$gt' => Time.parse(ten_am_pacific) - 1.second,
            '$lt' => Time.parse(ten_am_pacific) + 1.second
          }
        ).to_a.should == [@pacific_event]
      end

    end

    describe "searching by timestamp.normalized" do

      it "should return both events when searching a 10:00 UTC range" do
        Event.where(
          "timestamp.normalized" => {
            '$gt' => Time.parse(ten_am_utc) - 1.second,
            '$lt' => Time.parse(ten_am_utc) + 1.second
          }
        ).to_a.should == [@eastern_event, @pacific_event]
      end

      it "should not return any events when searching a 10:00 ET range" do
        Event.where(
          "timestamp.normalized" => {
            '$gt' => Time.parse(ten_am_eastern) - 1.second,
            '$lt' => Time.parse(ten_am_eastern) + 1.second
          }
        ).to_a.should == []
      end

      it "should not return any events when searching a 10:00 PT range" do
        Event.where(
          "timestamp.normalized" => {
            '$gt' => Time.parse(ten_am_pacific) - 1.second,
            '$lt' => Time.parse(ten_am_pacific) + 1.second
          }
        ).to_a.should == []
      end

    end

  end

end