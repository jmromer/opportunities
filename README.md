opportunity_parser
==================

[![CircleCI][circleci-svg]][circleci-badge]

Purpose
-------

To help job seekers find job opportunities, this library parses job posting data
provided in mixed formats (CSV-like and as lines of JSON) and displays a
sorted, filterable, consistified summary.

Features
-------

- Processes opportunities encoded in mixed CSV and JSON
- Sorts by Title
- Filterable by State
- Filterable by arbitrary predicates

Example
-------

### Input

```
Lead Chef, Chipotle, Denver, CO, 10, 15
Stunt Double, Equity, Los Angeles, CA, 15, 25
Manager of Fun, IBM, Albany, NY, 30, 40
Associate Tattoo Artist, Tit 4 Tat, Brooklyn, NY, 250, 275
Assistant to the Regional Manager, IBM, Scranton, PA, 10, 15
Lead Guitarist, Philharmonic, Woodstock, NY, 100, 200
--JSON FORMAT BELOW--
{"name": "Spaceship Repairman", "location": {"city": "Olympus Mons", "state": "Mars"}, "organization": "Interplanetary Enterprises", "pay": {"min": 100, "max": 200}}
{"name": "Lead Cephalopod Caretaker", "location": {"city": "Atlantis", "state": "Oceania"}, "organization": "Deep Adventures", "pay": {"min": 10, "max": 15}}
```

### Output

```
All Opportunities
Title: Assistant to the Regional Manager, Organization: IBM, Location: Scranton, PA, Pay: 10-15
Title: Associate Tattoo Artist, Organization: Tit 4 Tat, Location: Brooklyn, NY, Pay: 250-275
Title: Lead Cephalopod Caretaker, Organization: Deep Adventures, Location: Atlantis, Oceania, Pay: 10-15
Title: Lead Chef, Organization: Chipotle, Location: Denver, CO, Pay: 10-15
Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
Title: Manager of Fun, Organization: IBM, Location: Albany, NY, Pay: 30-40
Title: Spaceship Repairman, Organization: Interplanetary Enterprises, Location: Olympus Mons, Mars, Pay: 100-200
Title: Stunt Double, Organization: Equity, Location: Los Angeles, CA, Pay: 15-25

New York Opportunities
Title: Associate Tattoo Artist, Organization: Tit 4 Tat, Location: Brooklyn, NY, Pay: 250-275
Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
Title: Manager of Fun, Organization: IBM, Location: Albany, NY, Pay: 30-40

Lead Roles
Title: Lead Cephalopod Caretaker, Organization: Deep Adventures, Location: Atlantis, Oceania, Pay: 10-15
Title: Lead Chef, Organization: Chipotle, Location: Denver, CO, Pay: 10-15
Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
```

Design
------

```ruby
# lib/opportunities.rb L3-L16

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
```

Testing
-------

Example test:

```ruby
# spec/opportunities/opportunity_parser_spec.rb L205-L260 (84b4eda77a)

context "given multiple filters" do
  it "returns additional filtered listings" do
    csv_fields_list = %w[title organization city state pay_min pay_max]
    input_string = <<~STR
      Lead Chef, Chipotle, Denver, CO, 10, 15
      Stunt Double, Equity, Los Angeles, CA, 15, 25
      Manager of Fun, IBM, Albany, NY, 30, 40
      Associate Tattoo Artist, Tit 4 Tat, Brooklyn, NY, 250, 275
      Assistant to the Regional Manager, IBM, Scranton, PA, 10, 15
      Lead Guitarist, Philharmonic, Woodstock, NY, 100, 200
      --JSON FORMAT BELOW--
      {"name": "Spaceship Repairman", "location": {"city": "Olympus Mons", "state": "Mars"}, "organization": "Interplanetary Enterprises", "pay": {"min": 100, "max": 200}}
      {"name": "Lead Cephalopod Caretaker", "location": {"city": "Atlantis", "state": "Oceania"}, "organization": "Deep Adventures", "pay": {"min": 10, "max": 15}}
    STR
    filters_list = [
      {
        label: "New York Opportunities",
        predicate: -> (record) { record.state == "NY" },
      },
      {
        label: "Lead Roles",
        predicate: -> (record) { record.title =~ /Lead/ },
      },
    ]

    output = described_class.parse(
      input_string,
      fields_list: csv_fields_list,
      csv_json_separator: "--JSON FORMAT BELOW--",
      filters: filters_list,
    )

    formatted_output = <<~TXT
      All Opportunities
      Title: Assistant to the Regional Manager, Organization: IBM, Location: Scranton, PA, Pay: 10-15
      Title: Associate Tattoo Artist, Organization: Tit 4 Tat, Location: Brooklyn, NY, Pay: 250-275
      Title: Lead Cephalopod Caretaker, Organization: Deep Adventures, Location: Atlantis, Oceania, Pay: 10-15
      Title: Lead Chef, Organization: Chipotle, Location: Denver, CO, Pay: 10-15
      Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
      Title: Manager of Fun, Organization: IBM, Location: Albany, NY, Pay: 30-40
      Title: Spaceship Repairman, Organization: Interplanetary Enterprises, Location: Olympus Mons, Mars, Pay: 100-200
      Title: Stunt Double, Organization: Equity, Location: Los Angeles, CA, Pay: 15-25

      New York Opportunities
      Title: Associate Tattoo Artist, Organization: Tit 4 Tat, Location: Brooklyn, NY, Pay: 250-275
      Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
      Title: Manager of Fun, Organization: IBM, Location: Albany, NY, Pay: 30-40

      Lead Roles
      Title: Lead Cephalopod Caretaker, Organization: Deep Adventures, Location: Atlantis, Oceania, Pay: 10-15
      Title: Lead Chef, Organization: Chipotle, Location: Denver, CO, Pay: 10-15
      Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
    TXT
    expect(output).to eq formatted_output.strip
  end
end
```
<sup>
  <a href="https://github.com/jmromer/opportunities/blob/84b4eda77a/spec/opportunities/opportunity_parser_spec.rb#L205-L260">
    spec/opportunities/opportunity_parser_spec.rb#L205-L260 (84b4eda77a)
  </a>
</sup>
<p></p>


[circleci-badge]: https://circleci.com/gh/jmromer/opportunities/tree/master
[circleci-svg]: https://circleci.com/gh/jmromer/opportunities/tree/master.svg?style=svg
