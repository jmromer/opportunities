# frozen_string_literal: true

require "opportunities"
require "set"

module Opportunities
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

      filtered_output = filters.each_with_object(String.new).with_index do |(filter, output_str), i|
        filtered_listing = row_listing.select(&filter[:predicate])
        filter_label = filter[:label] || "Opportunities Set #{i.next}"

        output_str << <<~STR
          #{filter_label}
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
end
