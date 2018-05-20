# frozen_string_literal: true

require "opportunities/opportunity"

module Opportunities
  RSpec.describe Opportunity do
    describe "#title" do
      context "given a 'title' attribute" do
        it "sets the title to the passed-in title" do
          opp = Opportunity.new(title: "Some Title")
          expect(opp.title).to eq "Some Title"
        end
      end

      context "given a 'name' attribute" do
        it "sets the title to the passed-in 'name'" do
          opp = Opportunity.new(name: "Some Title Name")
          expect(opp.title).to eq "Some Title Name"
        end
      end
    end

    describe "#pay" do
      context "given nested pay values" do
        it "returns the properly formatted range" do
          opp = Opportunity.new(pay_min: "10", pay_max: "15")
          expect(opp.pay).to eq "10-15"
        end
      end

      context "given flat pay values" do
        it "returns the properly formatted range" do
          opp = Opportunity.new(pay: {min: "10", max: "20"})
          expect(opp.pay).to eq "10-20"
        end
      end

      context "given only one value" do
        it "returns just the one value" do
          opp = Opportunity.new(pay: {min: "10"})
          expect(opp.pay).to eq "10"
        end
      end
    end

    describe "#location" do
      context "given a city and state" do
        it "returns both, comma-separated" do
          opp = Opportunity.new(city: "New York", state: "NY")
          expect(opp.location).to eq "New York, NY"
        end
      end

      context "given a city and no state" do
        it "returns only the city" do
          opp = Opportunity.new(city: "New York")
          expect(opp.location).to eq "New York"
        end
      end

      context "given a state and no city" do
        it "returns only the state" do
          opp = Opportunity.new(state: "California")
          expect(opp.location).to eq "California"
        end
      end

      context "given a nested city and state" do
        it "correctly returns both" do
          opp = Opportunity.new(location: {city: "New York", state: "NY"})
          expect(opp.location).to eq "New York, NY"
        end
      end
    end

    describe "#eql?" do
      context "given empty field values" do
        it "returns true" do
          opp1 = Opportunity.new
          opp2 = Opportunity.new
          expect(opp1).to eql opp2
        end
      end

      context "given populated identical field values" do
        it "returns true" do
          opp1 = Opportunity.new(title: "Job Title")
          opp2 = Opportunity.new(title: "Job Title")
          expect(opp1).to eql opp2
        end
      end

      context "given populated differing field values" do
        it "returns false" do
          opp1 = Opportunity.new(title: "Job Title", organization: "Wag")
          opp2 = Opportunity.new(title: "Job Title", organization: "Rover")
          expect(opp1).to_not eql opp2
        end
      end
    end

    describe "#to_s" do
      it "returns correctly formatted field values" do
        attrs = {
          title: "Job Title",
          organization: "Org",
          city: "New York",
          state: "NY",
          pay_min: "10",
          pay_max: "20",
        }

        opportunity_string = Opportunity.new(attrs).to_s

        expect(opportunity_string).to(eq <<~STR.chomp)
          Title: Job Title, Organization: Org, Location: New York, NY, Pay: 10-20
        STR
      end
    end

    describe "#<=>" do
      it "sorts by title" do
        opp1 = Opportunity.new(title: "Job1", organization: "Org9")
        opp2 = Opportunity.new(title: "Job2", organization: "Org1")
        opp3 = Opportunity.new(title: "Job3", organization: "Org5")
        list = [opp1, opp2, opp3]

        sorted = list.shuffle.sort

        expect(sorted).to eq list
      end
    end
  end
end
