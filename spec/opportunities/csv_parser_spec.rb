# frozen_string_literal: true

require "opportunities/csv_parser"

module Opportunities
  RSpec.describe CSVParser do
    describe "#parse" do
      it "parses a csv string into a csv table" do
        fields = %w[name age]
        csv_values = "joe, 12\njane, 15"

        table = described_class.parse(csv_values, headers: fields)

        expect(table).to be_an_instance_of(CSV::Table)
        expect(table[0].to_h).to eq(name: "joe", age: "12")
        expect(table[1].to_h).to eq(name: "jane", age: "15")
      end

      it "parses a csv string into a csv table" do
        csv_values = "joe, 12\njane, 15"

        parse_attempt = -> { described_class.parse(csv_values, headers: []) }

        expect { parse_attempt.call }.to raise_error(ArgumentError, /headers list is empty/)
      end
    end
  end
end
