# frozen_string_literal: true

require "csv_parser"
require "json_line_parser"
require "opportunity"
require "set"

module OpportunityParser
  def self.parse(string, fields_list: [], csv_json_separator: "--json below--")
    csv_string, json_string =
      string.split(csv_json_separator)

    rows_from_csv =
      CSVParser
        .parse(csv_string, fields_list)
        .map { |record| Opportunity.new(**record) }

    rows_from_json =
      JSONLineParser
        .parse_lines(json_string)
        .map { |record| Opportunity.new(**record) }

    row_listing =
      SortedSet
        .new(rows_from_csv + rows_from_json)
        .to_a
        .join("\n")

    <<~STR
      All Opportunities
      #{row_listing}
    STR
  end
end
