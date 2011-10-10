#encoding: utf-8

require "spec_helper"

describe "Mongoid::Metastamp::Time search" do

  let :ten_am_utc do
    "2011-10-05T10:00:00-00:00"
  end

  let :ten_am_eastern do
    "2011-10-05T10:00:00-04:00"
  end

  let :ten_am_pacific do
    "2011-10-05T10:00:00-07:00"
  end

  context "set to 10 AM with multiple timezones" do

    let :est_event do
      Event.create(timestamp: ten_am_eastern)
    end

    let :pacific_event do
      Event.create(timestamp: ten_am_pacific)
    end

    describe "searching by timestamp.time" do

      it "using a 10 AM UTC range should not return any events" do
        Event.where(
          "timestamp.time" => { '$gt' => Time.parse(ten_am_utc) - 1.minute },
          "timestamp.time" => { '$lt' => Time.parse(ten_am_utc) + 1.minute }
        ).should == []
      end

      it "using a 10 AM ET range should only return the ET event" do
        Event.where(
          "timestamp.time" => { '$gt' => Time.parse(ten_am_eastern) - 1.minute },
          "timestamp.time" => { '$lt' => Time.parse(ten_am_eastern) + 1.minute }
        ).should == [est_event]
      end

      it "using a 10 AM PT range should only return the PT event" do
        Event.where(
          "timestamp.time" => { '$gt' => Time.parse(ten_am_pacific) - 1.minute },
          "timestamp.time" => { '$lt' => Time.parse(ten_am_pacific) + 1.minute }
        ).should == [pacific_event]
      end

    end

    describe "searching by timestamp.normalized" do

      it "using a 10 AM UTC range should return both events" do
        Event.where(
          "timestamp.normalized" => { '$gt' => Time.parse(ten_am_utc) - 1.minute },
          "timestamp.normalized" => { '$lt' => Time.parse(ten_am_utc) + 1.minute }
        ).should == [est_event, pacific_event]
      end

    end

  end

end