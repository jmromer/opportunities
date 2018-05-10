# frozen_string_literal: true

require "csv_parser"
require "json_line_parser"
require "opportunity"
require "set"

module OpportunityParser
  def self.parse(string, filter: nil, filter_label: nil, fields_list: [], csv_json_separator: "--json below--")
    csv_string, json_string =
      string.split(csv_json_separator)

    rows_from_csv =
      CSVParser
        .parse(csv_string, headers: fields_list)
        .map { |record| Opportunity.new(**record) }

    rows_from_json =
      JSONLineParser
        .parse_lines(json_string)
        .map { |record| Opportunity.new(**record) }

    row_listing =
      SortedSet
        .new(rows_from_csv + rows_from_json)
        .to_a

    output_string = <<~STR
      All Opportunities
      #{row_listing.join("\n")}
    STR

    return output_string if filter.nil?

    filtered_listing = row_listing.select(&filter)

    <<~STR
      #{output_string}
      #{filter_label || "Filtered"} Opportunities
      #{filtered_listing.join("\n")}
    STR
  end
end
