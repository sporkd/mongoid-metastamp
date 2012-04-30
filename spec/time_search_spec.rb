#encoding: utf-8

require "spec_helper"

describe "Mongoid::Metastamp::Time" do

  let :eastern_zone do
    "Eastern Time (US & Canada)"
  end

  let :pacific_zone do
    "Pacific Time (US & Canada)"
  end

  let :utc_zone do
    "UTC"
  end

  let :wed_oct_5_ten_am do
    "2011-10-05 10:00:00"
  end

  context "given a 10:00 eastern and a 10:00 pacific timestamp" do

    before :each do
      Time.zone = eastern_zone
      @ten_am_eastern = Time.zone.parse(wed_oct_5_ten_am)
      @eastern_event = Event.create(timestamp: @ten_am_eastern)

      Time.zone = pacific_zone
      @ten_am_pacific = Time.zone.parse(wed_oct_5_ten_am)
      @pacific_event = Event.create(timestamp: @ten_am_pacific)

      Time.zone = utc_zone
      @ten_am_utc = Time.zone.parse(wed_oct_5_ten_am)
    end

    describe "searching by timestamp" do

      it "should not return any events when searching a 10:00 UTC range" do
        Event.where(
          :timestamp.gt => @ten_am_utc - 1.second,
          :timestamp.lt => @ten_am_utc + 1.second
        ).to_a.should == []
      end
          
      it "should only return the ET event when searching a 10:00 ET range" do
        Event.where(
          :timestamp.gt =>  @ten_am_eastern - 1.second,
          :timestamp.lt => @ten_am_eastern + 1.second
        ).to_a.should == [@eastern_event]
      end
    
      it "should only return the PT event when searching a 10:00 PT range" do
        Event.where(
          :timestamp.gt => @ten_am_pacific - 1.second,
          :timestamp.lt => @ten_am_pacific + 1.second
        ).to_a.should == [@pacific_event]
      end
    
    end

    describe "searching by timestamp.time" do

      it "should not return any events when searching a 10:00 UTC range" do
        Event.where(
          "timestamp.time" => {
            '$gt' => @ten_am_utc - 1.second,
            '$lt' => @ten_am_utc + 1.second
          }
        ).to_a.should == []
      end

      it "should only return the ET event when searching a 10:00 ET range" do
        Event.where(
          "timestamp.time" => {
            '$gt' => @ten_am_eastern - 1.second,
            '$lt' => @ten_am_eastern + 1.second
          }
        ).to_a.should == [@eastern_event]
      end

      it "should only return the PT event when searching a 10:00 PT range" do
        Event.where(
          "timestamp.time" => { 
            '$gt' => @ten_am_pacific - 1.second,
            '$lt' => @ten_am_pacific + 1.second
          }
        ).to_a.should == [@pacific_event]
      end

    end

    describe "searching by timestamp.normalized" do

      it "should return both events when searching a 10:00 UTC range" do
        Event.where(
          "timestamp.normalized" => {
            '$gt' => @ten_am_utc - 1.second,
            '$lt' => @ten_am_utc + 1.second
          }
        ).to_a.should == [@eastern_event, @pacific_event]
      end

      it "should not return any events when searching a 10:00 ET range" do
        Event.where(
          "timestamp.normalized" => {
            '$gt' => @ten_am_eastern - 1.second,
            '$lt' => @ten_am_eastern + 1.second
          }
        ).to_a.should == []
      end

      it "should not return any events when searching a 10:00 PT range" do
        Event.where(
          "timestamp.normalized" => {
            '$gt' => @ten_am_pacific - 1.second,
            '$lt' => @ten_am_pacific + 1.second
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

      it "should return no events when searching UTC" do
        Event.where("timestamp.zone" => utc_zone).to_a.should == []
      end

      it "should return only the eastern event when searching Eastern Time (US & Canada)" do
        Event.where("timestamp.zone" => eastern_zone).to_a.should == [@eastern_event]
      end

      it "should return only the pacific event when searching Pacific Time (US & Canada)" do
        Event.where("timestamp.zone" => pacific_zone).to_a.should == [@pacific_event]
      end

    end

  end

end