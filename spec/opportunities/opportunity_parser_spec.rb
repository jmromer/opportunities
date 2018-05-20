# frozen_string_literal: true

require "opportunities/opportunity_parser"

module Opportunities
  RSpec.describe OpportunityParser do
    describe "#parse" do
      context "given a CSV-like string" do
        it "parses CSVish string into a sorted opportunities listing" do
          csv_fields = %w[title organization city state pay_min pay_max]
          csv_values = <<~CSV
            Lead Chef, Chipotle, Denver, CO, 10, 15
            Stunt Double, Equity, Los Angeles, CA, 15, 25
            Manager of Fun, IBM, Albany, NY, 30, 40
            Associate Tattoo Artist, Tit 4 Tat, Brooklyn, NY, 250, 275
            Assistant to the Regional Manager, IBM, Scranton, PA, 10, 15
            Lead Guitarist, Philharmonic, Woodstock, NY, 100, 200
          CSV

          output = described_class.parse(csv_values, fields_list: csv_fields)

          formatted_output = <<~TXT
            All Opportunities
            Title: Assistant to the Regional Manager, Organization: IBM, Location: Scranton, PA, Pay: 10-15
            Title: Associate Tattoo Artist, Organization: Tit 4 Tat, Location: Brooklyn, NY, Pay: 250-275
            Title: Lead Chef, Organization: Chipotle, Location: Denver, CO, Pay: 10-15
            Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
            Title: Manager of Fun, Organization: IBM, Location: Albany, NY, Pay: 30-40
            Title: Stunt Double, Organization: Equity, Location: Los Angeles, CA, Pay: 15-25
          TXT
          expect(output).to eq formatted_output.strip
        end

        it "is robust to changes in column order and spacing" do
          csv_fields = %w[organization title city state pay_min pay_max]
          csv_values = <<~CSV
            Chipotle,     Lead Chef,                         Denver,      CO, 10,  15
            Equity,       Stunt Double,                      Los Angeles, CA, 15,  25
            IBM,          Manager of Fun,                    Albany,      NY, 30,  40
            Tit 4 Tat,    Associate Tattoo Artist,           Brooklyn,    NY, 250, 275
            IBM,          Assistant to the Regional Manager, Scranton,    PA, 10,  15
            Philharmonic, Lead Guitarist,                    Woodstock,   NY, 100, 200
          CSV

          output = described_class.parse(csv_values, fields_list: csv_fields)

          formatted_output = <<~TXT
            All Opportunities
            Title: Assistant to the Regional Manager, Organization: IBM, Location: Scranton, PA, Pay: 10-15
            Title: Associate Tattoo Artist, Organization: Tit 4 Tat, Location: Brooklyn, NY, Pay: 250-275
            Title: Lead Chef, Organization: Chipotle, Location: Denver, CO, Pay: 10-15
            Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
            Title: Manager of Fun, Organization: IBM, Location: Albany, NY, Pay: 30-40
            Title: Stunt Double, Organization: Equity, Location: Los Angeles, CA, Pay: 15-25
          TXT
          expect(output).to eq formatted_output.strip
        end
      end

      context "given a mix of CSV-like and JSON data" do
        it "can parse a mix of csv and json" do
          fields_list = %w[title organization city state pay_min pay_max]
          json_split_string = "--JSON-INPUT-BELOW--"
          input_string = <<~STR
            Stunt Double, Equity, Los Angeles, CA, 15, 25
            Manager of Fun, IBM, Albany, NY, 30, 40
            Associate Tattoo Artist, Tit 4 Tat, Brooklyn, NY, 250, 275
            Assistant to the Regional Manager, IBM, Scranton, PA, 10, 15
            Lead Guitarist, Philharmonic, Woodstock, NY, 100, 200
            --JSON-INPUT-BELOW--
            {"name": "Dog Walker", "organization": "Wag", "city": "Flushing", "state": "NY", "pay": {"min":10, "max":15}}
            {"name": "Cat Walker", "organization": "Rover", "city": "Forest Hills", "state": "NY", "pay": {"min":10, "max":15}}
          STR

          output = described_class.parse(input_string,
                                         fields_list: fields_list,
                                         csv_json_separator: json_split_string)

          formatted_output = <<~TXT
            All Opportunities
            Title: Assistant to the Regional Manager, Organization: IBM, Location: Scranton, PA, Pay: 10-15
            Title: Associate Tattoo Artist, Organization: Tit 4 Tat, Location: Brooklyn, NY, Pay: 250-275
            Title: Cat Walker, Organization: Rover, Location: Forest Hills, NY, Pay: 10-15
            Title: Dog Walker, Organization: Wag, Location: Flushing, NY, Pay: 10-15
            Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
            Title: Manager of Fun, Organization: IBM, Location: Albany, NY, Pay: 30-40
            Title: Stunt Double, Organization: Equity, Location: Los Angeles, CA, Pay: 15-25
          TXT
          expect(output).to eq formatted_output.strip
        end

        it "can parse mixed input with no json" do
          fields_list = %w[title organization city state pay_min pay_max]
          json_split_string = "--NO-JSON-INPUT-BELOW--"
          input_string = <<~STR
            Lead Guitarist, Philharmonic, Woodstock, NY, 100, 200
            Associate Tattoo Artist, Tit 4 Tat, Brooklyn, NY, 250, 275
            Assistant to the Regional Manager, IBM, Scranton, PA, 10, 15
            --NO-JSON-INPUT-BELOW--
          STR

          output = described_class.parse(input_string,
                                         fields_list: fields_list,
                                         csv_json_separator: json_split_string)

          formatted_output = <<~TXT
            All Opportunities
            Title: Assistant to the Regional Manager, Organization: IBM, Location: Scranton, PA, Pay: 10-15
            Title: Associate Tattoo Artist, Organization: Tit 4 Tat, Location: Brooklyn, NY, Pay: 250-275
            Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
          TXT
          expect(output).to eq formatted_output.strip
        end

        it "can parse mixed input with no csv" do
          fields_list = %w[title organization city state pay_min pay_max]
          json_split_string = "--JSON-INPUT-BELOW--"
          input_string = <<~STR
            --JSON-INPUT-BELOW--
            {"name": "Lead Cat Walker", "organization": "Rover", "city": "Forest Hills", "state": "NY", "pay": {"min":10, "max":15}}
            {"name": "Dog Walker", "organization": "Wag", "city": "Flushing", "state": "NY", "pay": {"min":10, "max":15}}
          STR

          output = described_class.parse(input_string,
                                         fields_list: fields_list,
                                         csv_json_separator: json_split_string)

          formatted_output = <<~TXT
            All Opportunities
            Title: Dog Walker, Organization: Wag, Location: Flushing, NY, Pay: 10-15
            Title: Lead Cat Walker, Organization: Rover, Location: Forest Hills, NY, Pay: 10-15
          TXT
          expect(output).to eq formatted_output.strip.strip
        end
      end

      context "given duplicate records" do
        it "uniqueifies the list of records it outputs" do
          fields_list = %w[title organization city state pay_min pay_max]
          json_split_string = "--JSON-INPUT-BELOW--"
          input_string = <<~STR
            Stunt Double, Equity, Los Angeles, CA, 15, 25
            Stunt Double, Equity, Los Angeles, CA, 15, 25
            Dog Walker, Wag, Flushing, NY, 10, 15
            --JSON-INPUT-BELOW--
            {"name": "Dog Walker", "organization": "Wag", "city": "Flushing", "state": "NY", "pay": {"min":10, "max":15}}
            {"name": "Dog Walker", "organization": "Wag", "city": "Flushing", "state": "NY", "pay": {"min":10, "max":15}}
          STR

          output = described_class.parse(input_string,
                                         fields_list: fields_list,
                                         csv_json_separator: json_split_string)

          formatted_output = <<~TXT
            All Opportunities
            Title: Dog Walker, Organization: Wag, Location: Flushing, NY, Pay: 10-15
            Title: Stunt Double, Organization: Equity, Location: Los Angeles, CA, Pay: 15-25
          TXT
          expect(output).to eq formatted_output.strip
        end
      end

      context "given a state filter" do
        it "returns an additional state-specific listing" do
          csv_fields_list = %w[title organization city state pay_min pay_max]
          input_string = <<~STR
            Lead Chef, Chipotle, Denver, CO, 10, 15
            Stunt Double, Equity, Los Angeles, CA, 15, 25
            Manager of Fun, IBM, Albany, NY, 30, 40
            Associate Tattoo Artist, Tit 4 Tat, Brooklyn, NY, 250, 275
            Assistant to the Regional Manager, IBM, Scranton, PA, 10, 15
            Lead Guitarist, Philharmonic, Woodstock, NY, 100, 200
          STR
          filters_list = [
            {
              label: "New York Opportunities",
              predicate: -> (record) { record.state == "NY" },
            },
          ]

          output = described_class.parse(
            input_string,
            fields_list: csv_fields_list,
            filters: filters_list,
          )

          formatted_output = <<~TXT
            All Opportunities
            Title: Assistant to the Regional Manager, Organization: IBM, Location: Scranton, PA, Pay: 10-15
            Title: Associate Tattoo Artist, Organization: Tit 4 Tat, Location: Brooklyn, NY, Pay: 250-275
            Title: Lead Chef, Organization: Chipotle, Location: Denver, CO, Pay: 10-15
            Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
            Title: Manager of Fun, Organization: IBM, Location: Albany, NY, Pay: 30-40
            Title: Stunt Double, Organization: Equity, Location: Los Angeles, CA, Pay: 15-25

            New York Opportunities
            Title: Associate Tattoo Artist, Organization: Tit 4 Tat, Location: Brooklyn, NY, Pay: 250-275
            Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
            Title: Manager of Fun, Organization: IBM, Location: Albany, NY, Pay: 30-40
          TXT
          expect(output).to eq formatted_output.strip
        end
      end

      context "given multiple filters" do
        it "returns additional filtered listings" do
          csv_fields_list = %w[title organization city state pay_min pay_max]
          input_string = <<~STR
            Lead Chef, Chipotle, Denver, CO, 10, 15
            Stunt Double, Equity, Los Angeles, CA, 15, 25
            Manager of Fun, IBM, Albany, NY, 30, 40
            Associate Tattoo Artist, Tit 4 Tat, Brooklyn, NY, 250, 275
            Assistant to the Regional Manager, IBM, Scranton, PA, 10, 15
            Lead Guitarist, Philharmonic, Woodstock, NY, 100, 200
            --JSON FORMAT BELOW--
            {"name": "Spaceship Repairman", "location": {"city": "Olympus Mons", "state": "Mars"}, "organization": "Interplanetary Enterprises", "pay": {"min": 100, "max": 200}}
            {"name": "Lead Cephalopod Caretaker", "location": {"city": "Atlantis", "state": "Oceania"}, "organization": "Deep Adventures", "pay": {"min": 10, "max": 15}}
          STR
          filters_list = [
            {
              label: "New York Opportunities",
              predicate: -> (record) { record.state == "NY" },
            },
            {
              label: "Lead Roles",
              predicate: -> (record) { record.title =~ /Lead/ },
            },
          ]

          output = described_class.parse(
            input_string,
            fields_list: csv_fields_list,
            csv_json_separator: "--JSON FORMAT BELOW--",
            filters: filters_list,
          )

          formatted_output = <<~TXT
            All Opportunities
            Title: Assistant to the Regional Manager, Organization: IBM, Location: Scranton, PA, Pay: 10-15
            Title: Associate Tattoo Artist, Organization: Tit 4 Tat, Location: Brooklyn, NY, Pay: 250-275
            Title: Lead Cephalopod Caretaker, Organization: Deep Adventures, Location: Atlantis, Oceania, Pay: 10-15
            Title: Lead Chef, Organization: Chipotle, Location: Denver, CO, Pay: 10-15
            Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
            Title: Manager of Fun, Organization: IBM, Location: Albany, NY, Pay: 30-40
            Title: Spaceship Repairman, Organization: Interplanetary Enterprises, Location: Olympus Mons, Mars, Pay: 100-200
            Title: Stunt Double, Organization: Equity, Location: Los Angeles, CA, Pay: 15-25

            New York Opportunities
            Title: Associate Tattoo Artist, Organization: Tit 4 Tat, Location: Brooklyn, NY, Pay: 250-275
            Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
            Title: Manager of Fun, Organization: IBM, Location: Albany, NY, Pay: 30-40

            Lead Roles
            Title: Lead Cephalopod Caretaker, Organization: Deep Adventures, Location: Atlantis, Oceania, Pay: 10-15
            Title: Lead Chef, Organization: Chipotle, Location: Denver, CO, Pay: 10-15
            Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
          TXT
          expect(output).to eq formatted_output.strip
        end
      end
    end
  end
end
