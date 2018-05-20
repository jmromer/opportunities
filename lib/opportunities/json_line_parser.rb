# frozen_string_literal: true

require "json"

module Opportunities
  module JSONLineParser
    def self.parse_lines(string, logger: nil)
      json_records_string = (string || "").strip
      return [] if json_records_string.empty?

      json_records_string
        .split("\n")
        .map { |json_string| parse_line(json_string, logger: logger) }
    end

    def self.parse_line(json_string, logger: nil)
      JSON.parse(json_string, symbolize_names: true)
    rescue JSON::ParserError => err
      logger&.fatal(<<~ERR)
        JSON parser received invalid input:
        '#{clean_json_string}'
      ERR
      raise err
    end
  end
end
