#encoding: utf-8

require "spec_helper"

describe Mongoid::Metastamp do

  let :ten_am_utc do
    "2011-10-05T10:00:00-00:00"
  end

  let :ten_am_eastern do
    "2011-10-05T10:00:00-04:00"
  end

  let :ten_am_pacific do
    "2011-10-05T10:00:00-07:00"
  end

  describe "using a custom field of type Mongoid::Metastamp::Time" do

    context "on 10 AM events across multiple timezones" do

      let :est_event do
        Event.create(timestamp: ten_am_eastern)
      end

      let :pst_event do
        Event.create(timestamp: ten_am_pacific)
      end

      it "should deserialize the EST timestamp as 10 AM EST" do
        est_event.timestamp.should == Time.parse(ten_am_eastern)
      end

      it "should deserialize the PST timestamp as 10 AM PST" do
        pst_event.timestamp.should == Time.parse(ten_am_pacific)
      end

      describe "searching by timestamp.in_zone" do

        it "using a 10 AM UTC range should not return any events" do
          Event.where(
            "timestamp.in_zone" => { '$gt' => Time.parse(ten_am_utc) - 1.minute },
            "timestamp.in_zone" => { '$lt' => Time.parse(ten_am_utc) + 1.minute }
          ).should == []
        end

        it "using a 10 AM EST range should only return the EST event" do
          Event.where(
            "timestamp.in_zone" => { '$gt' => Time.parse(ten_am_eastern) - 1.minute },
            "timestamp.in_zone" => { '$lt' => Time.parse(ten_am_eastern) + 1.minute }
          ).should == [est_event]
        end

        it "using a 10 AM PST range should only return the PST event" do
          Event.where(
            "timestamp.in_zone" => { '$gt' => Time.parse(ten_am_pacific) - 1.minute },
            "timestamp.in_zone" => { '$lt' => Time.parse(ten_am_pacific) + 1.minute }
          ).should == [pst_event]
        end

      end

      describe "searching by timestamp.normalized" do

        it "using a 10 AM UTC range should return both events" do
          Event.where(
            "timestamp.normalized" => { '$gt' => Time.parse(ten_am_utc) - 1.minute },
            "timestamp.normalized" => { '$lt' => Time.parse(ten_am_utc) + 1.minute }
          ).should == [est_event, pst_event]
        end

      end

    end

  end

end