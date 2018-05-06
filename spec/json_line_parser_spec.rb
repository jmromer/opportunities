# frozen_string_literal: true

require "json_line_parser"

RSpec.describe JSONLineParser do
  describe "#parse_lines" do
    it "parses a string of json lines into a list of hashes" do
      json_lines = <<~STR
        {"one": 1, "two": 2}
        {"three": 3, "four": 4}
      STR

      output = described_class.parse_lines(json_lines)

      expect(output).to eq [{one: 1, two: 2}, {three: 3, four: 4}]
    end
  end

  describe "#parse_line" do
    it "parses json into a hash" do
      json_lines = <<~STR
        {"one": 1, "two": 2, "three": {"four": 4}}
      STR

      output = described_class.parse_line(json_lines)

      expect(output).to eq(one: 1, two: 2, three: {four: 4})
    end
  end
end
