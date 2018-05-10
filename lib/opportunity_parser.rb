# frozen_string_literal: true

require "csv_parser"
require "json_line_parser"
require "opportunity"
require "set"

module OpportunityParser
  def self.parse(string, filters: [], fields_list: [], csv_json_separator: "--json below--")
    csv_string, json_string = string.split(csv_json_separator)

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

    filtered_output = filters.reduce(String.new) do |output_str, filter|
      filtered_listing = row_listing.select(&filter[:predicate])

      output_str << <<~STR.strip
        #{filter[:label] || "Filtered"} Opportunities
        #{filtered_listing.join("\n")}
      STR
    end

    <<~STR.strip
      All Opportunities
      #{row_listing.join("\n")}

      #{filtered_output}
    STR
  end
end
