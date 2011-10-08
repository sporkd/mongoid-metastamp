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

  describe "with custom field of type Mongoid::Metastamp::Time" do

    context "named timestamp" do

      context "when set to 10:00 AM PST" do

        let :pst_event do
          Event.create(timestamp: ten_am_pacific)
        end

        it "should have a timestamp field" do
          pst_event.should respond_to(:timestamp)
        end

        it "should deserialize the timestamp as 10 AM PST" do
          pst_event.timestamp.should == Time.parse(ten_am_pacific)
        end

        it "should be searchable by timestamp.time" do
          Event.where(
            "timestamp.time" => { '$gt' => Time.parse(ten_am_pacific) - 1.minute },
            "timestamp.time" => { '$lt' => Time.parse(ten_am_pacific) + 1.minute }
          ).should == [pst_event]
        end

        it "should be searchable by timestamp.universal_time" do
          Event.where(
            "timestamp.universal_time" => { '$gt' => Time.parse(ten_am_utc) - 1.minute },
            "timestamp.universal_time" => { '$lt' => Time.parse(ten_am_utc) + 1.minute }
          ).should == [pst_event]
        end

      end

    end

  end

end