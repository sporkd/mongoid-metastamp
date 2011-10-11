#encoding: utf-8

require "spec_helper"

describe "Mongoid::Metastamp::Time" do

  let :two_pm_pacific do
    "2011-10-05T14:00:00-07:00"
  end

  describe "compatibility with Time class" do

    class Legacy
      include Mongoid::Document
      field :timestamp, type: Time
    end

    let :instance do
      Legacy.create(timestamp: two_pm_pacific).reload
    end

    context "before upgrade" do

      it "should have a timestamp" do
        instance.timestamp.should == Time.parse(two_pm_pacific)
      end

      it "should store timestamp as a Time" do
        instance['timestamp'].class.should == Time
      end

    end

    context "after Mongoid::Metastamp upgrade" do

      before :each do
        instance
        Legacy.field(:timestamp, type: Mongoid::Metastamp::Time)
      end

      let :legacy do
        Legacy.find(instance.id)
      end

      it "should still be able to read legacy timestamps" do
        legacy.timestamp.should == Time.parse(two_pm_pacific)
      end
      
      describe "updating timestamp with the same time" do

        before :each do
          legacy.update_attribute(:timestamp, two_pm_pacific)
        end

        it "should now store timestamp as a Hash" do
          legacy['timestamp'].class.should == Hash
          legacy['timestamp']['time'].should == Time.parse(two_pm_pacific)
        end

        it "should still be compatible with the legacy timestamp" do
          legacy.timestamp.should == Time.parse(two_pm_pacific)
        end

      end

    end

  end

end