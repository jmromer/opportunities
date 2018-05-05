# frozen_string_literal: true

class Opportunity
  include Comparable
  attr_accessor :title, :organization, :location, :pay

  def initialize(title, organization, city, state, pay_lower_bound, pay_upper_bound)
    self.title = title
    self.organization = organization
    self.location = "#{city}, #{state}"
    self.pay = "#{pay_lower_bound}-#{pay_upper_bound}"
  end

  def <=>(other)
    title <=> other.title
  end

  def to_s
    fields = {}.tap do |field|
      field["Title"] = title
      field["Organization"] = organization
      field["Location"] = location
      field["Pay"] = pay
    end

    fields
      .map { |field, value| "#{field}: #{value}" }
      .join(", ")
  end
end
