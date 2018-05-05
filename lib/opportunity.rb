# frozen_string_literal: true

class Opportunity
  include Comparable
  attr_accessor :title, :organization, :location, :pay

  def initialize(values)
    self.title = values[:title]
    self.organization = values[:organization]
    self.location = "#{values[:city]}, #{values[:state]}"
    self.pay = extract_pay(values)
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

  private

  def extract_pay(values)
    pay_min = values[:pay_min]
    pay_max = values[:pay_max]
    pay = values.fetch(:pay, {})

    if pay_min && pay_max
      "#{pay_min}-#{pay_max}"
    elsif pay[:min] && pay[:max]
      "#{pay[:min]}-#{pay[:max]}"
    else
      ""
    end
  end
end
