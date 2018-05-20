# frozen_string_literal: true

module Opportunities
  # Models an individual opportunity record
  class Opportunity; end

  # Coordinating module.
  # Aggregates parsed records, applies filters, displays
  module OpportunityParser; end

  # Parse strings composed of CSV-like records
  module CSVParser; end

  # Parse strings composed of lines of JSON
  module JSONLineParser; end
end
