# frozen_string_literal: true

require "csv"
require "json"
require "logger"

require "opportunity"

module OpportunityParser
  def self.parse(input_string, fields_list: [], csv_json_separator: "--json below--")
    clean_csv_string, clean_json_string =
      extract_csv_and_json(input_string, separator: csv_json_separator)

    rows_from_csv = parse_csv(clean_csv_string, fields_list)
    rows_from_json = parse_json_records(clean_json_string)

    row_listing = (rows_from_csv + rows_from_json).sort.join("\n")

    <<~STR
      All Opportunities
      #{row_listing}
    STR
  rescue ArgumentError => err
    raise err
  end

  def self.extract_csv_and_json(string, separator:)
    csv_string, json_string = string.split(separator)
    [csv_string.strip, (json_string || "").strip]
  end

  def self.parse_csv(csv_string, fields_list)
    csv_with_headers = <<~CSV
      #{fields_list.join(",")}
      #{csv_string.gsub(/,\s+/, ",")}
    CSV

    CSV
      .parse(csv_with_headers, headers: true, header_converters: :symbol)
      .map { |record| Opportunity.new(**record) }
  rescue CSV::MalformedCSVError => err
    logger.fatal(<<~ERR)
      CSV parser received invalid input:
      '#{csv_with_headers}'
    ERR

    raise err
  end

  def self.parse_json_records(json_records_string)
    return [] if json_records_string.empty?

    json_records_string
      .split("\n")
      .map { |json_string| parse_json(json_string) }
      .map { |record| Opportunity.new(**record) }
  end

  def self.parse_json(json_string)
    JSON.parse(json_string, symbolize_names: true)
  rescue JSON::ParserError => err
    logger.fatal(<<~ERR)
      JSON parser received invalid input:
      '#{clean_json_string}'
    ERR
    raise err
  end

  def self.logger
    Logger.new(STDOUT).tap do |logger|
      logger.level = Logger::WARN
    end
  end
end
