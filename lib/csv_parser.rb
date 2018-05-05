# frozen_string_literal: true

require "csv"

class CSVParser
  def self.parse(csv_string, fields_list, logger = nil)
    csv_with_headers = <<~CSV
      #{fields_list.join(",")}
      #{csv_string.gsub(/,\s+/, ",")}
    CSV

    CSV
      .parse(csv_with_headers, headers: true, header_converters: :symbol)
      .map { |record| Opportunity.new(**record) }
  rescue CSV::MalformedCSVError => err
    logger&.fatal(<<~ERR)
      CSV parser received invalid input:
      '#{csv_with_headers}'
    ERR

    raise err
  end
end
