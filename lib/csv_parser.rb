# frozen_string_literal: true

require "csv"

class CSVParser
  def self.parse(csv_string, fields_list = [], logger = nil)
    cleaned_csv = csv_string.strip.gsub(/,\s+/, ",")

    CSV.parse(cleaned_csv,
              headers: fields_list,
              header_converters: :symbol)
  rescue CSV::MalformedCSVError => err
    logger&.fatal(<<~ERR)
      CSV parser received invalid input:
      '#{csv_with_headers}'
    ERR

    raise err
  end
end
