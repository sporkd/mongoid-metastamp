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

    describe "searching by timestamp.year" do

      it "should not return any events for 2010" do
        Event.where("timestamp.year" => 2010).count.should == 0
      end

      it "should return both events for 2011" do
        Event.where("timestamp.year" => 2011).count.should == 2
      end

    end

    describe "searching by timestamp.month" do

      it "should not return any events when before October" do
        Event.where("timestamp.month" => {'$lt' => 10}).count.should == 0
      end

      it "should return both events for October" do
        Event.where("timestamp.month" => 10).count.should == 2
      end

    end

    describe "searching by timestamp.day" do

      it "should not return any events when after the 5th" do
        Event.where("timestamp.day" => {'$gt' => 5}).count.should == 0
      end

      it "should return both events for the 5th" do
        Event.where("timestamp.day" => 5).count.should == 2
      end

    end

    describe "searching by timestamp.wday" do

      it "should not return any events when thurs - tues" do
        Event.where("timestamp.wday" => {'$gte' => 4, '$lte' => 2}).count.should == 0
      end

      it "should return both events for wed" do
        Event.where("timestamp.wday" => 3).count.should == 2
      end

    end

    describe "searching by timestamp.hour" do

      it "should not return any events when before 10 AM" do
        Event.where("timestamp.hour" => {'$lt' => 10}).count.should == 0
      end

      it "should return both events for 10 AM" do
        Event.where("timestamp.hour" => 10).count.should == 2
      end

    end

    describe "searching by timestamp.min" do

      it "should not return any events when after 1 minute" do
        Event.where("timestamp.min" => {'$gte' => 1}).count.should == 0
      end

      it "should return both events for 0" do
        Event.where("timestamp.min" => 0).count.should == 2
      end

    end

    describe "searching by timestamp.sec" do

      it "should not return any events when after 1 second" do
        Event.where("timestamp.sec" => {'$gte' => 1}).count.should == 0
      end

      it "should return both events for 0" do
        Event.where("timestamp.sec" => 0).count.should == 2
      end

    end

    describe "searching by timestamp.zone" do

      it "should return only the eastern event when searching -04:00" do
        Event.where("timestamp.zone" => "-04:00").to_a.should == [@eastern_event]
      end

      it "should return only the pacific event when searching -07:00" do
        Event.where("timestamp.zone" => "-07:00").to_a.should == [@pacific_event]
      end

    end

  end

end