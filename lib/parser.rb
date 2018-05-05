# frozen_string_literal: true

require "opportunity"
require "csv"

class Parser
  def self.parse(csv_string)
    sorted_rows =
      CSV.parse(csv_string.gsub(", ", ","))
         .map { |row| Opportunity.new(*row) }
         .sort

    <<~STR
      All Opportunities
      #{sorted_rows.join("\n")}
    STR
  end
end
