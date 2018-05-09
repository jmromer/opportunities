# frozen_string_literal: true

require "csv"

module CSVParser
  def self.parse(csv_string, headers:, logger: nil)
    raise ArgumentError, "headers list is empty" if headers.empty?

    cleaned_csv = csv_string.strip.gsub(/,\s+/, ",")

    CSV.parse(cleaned_csv,
              headers: headers,
              header_converters: :symbol)
  rescue CSV::MalformedCSVError => err
    logger&.fatal(<<~ERR)
      CSV parser received invalid input:
      '#{csv_with_headers}'
    ERR

    raise err
  end
end
