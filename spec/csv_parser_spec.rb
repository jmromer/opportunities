# frozen_string_literal: true

require "csv_parser"

RSpec.describe CSVParser do
  describe "#parse" do
    it "parses a csv string into a csv table" do
      fields = %w[name age]
      csv_values = "joe, 12\njane, 15"

      table = described_class.parse(csv_values, fields)

      expect(table).to be_an_instance_of(CSV::Table)
      expect(table[0].to_h).to eq(name: "joe", age: "12")
      expect(table[1].to_h).to eq(name: "jane", age: "15")
    end
  end
end
