# frozen_string_literal: true

class Opportunity
  include Comparable
  attr_accessor :title, :organization, :city, :state, :pay_min, :pay_max

  def initialize(values = {})
    self.title = values[:title] || values[:name]
    self.organization = values[:organization]
    self.city = values[:city]
    self.state = values[:state]
    self.pay_min = values[:pay_min] || values.dig(:pay, :min)
    self.pay_max = values[:pay_max] || values.dig(:pay, :max)
  end

  def location
    @location ||= [city, state].compact.join(", ")
  end

  def pay
    @pay ||= [pay_min, pay_max].compact.join("-")
  end

  def <=>(other)
    title <=> other.title
  end

  def hash
    to_h.hash
  end

  def eql?(other)
    hash == other.hash
  end

  def to_s
    to_h
      .map { |field, value| "#{field}: #{value}" }
      .join(", ")
  end

  def to_h
    {}.tap do |field|
      field["Title"] = title
      field["Organization"] = organization
      field["Location"] = location
      field["Pay"] = pay
    end
  end
end
