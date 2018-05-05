# frozen_string_literal: true

require "csv_parser"
require "json_line_parser"
require "opportunity"
require "set"

module OpportunityParser
  def self.parse(input_string, fields_list: [], csv_json_separator: "--json below--")
    clean_csv_string, clean_json_string =
      extract_csv_and_json(input_string, separator: csv_json_separator)

    rows_from_csv =
      CSVParser.parse(clean_csv_string, fields_list)

    rows_from_json =
      JSONLineParser.parse_lines(clean_json_string)

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

  def self.extract_csv_and_json(string, separator:)
    csv_string, json_string = string.split(separator)
    [csv_string.strip, (json_string || "").strip]
  end
end
