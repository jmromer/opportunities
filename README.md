OpportunityParser
=================

[![CircleCI][circleci-svg]][circleci-badge]

Purpose
-------

To help job seekers find job opportunities, this library parses job posting data
in mixed formats and displays this data formatted.


Iteration 1: Input/Output
-------------------------

- Read input from a string literal
- Always print out sorted by Title
- Print out in the format:
```
Title: <Title>, Organization: <Organization>, Location: <City>, <State>, Pay: <Min>-<Max>
```

### Input

```
Lead Chef, Chipotle, Denver, CO, 10, 15
Stunt Double, Equity, Los Angeles, CA, 15, 25
Manager of Fun, IBM, Albany, NY, 30, 40
Associate Tattoo Artist, Tit 4 Tat, Brooklyn, NY, 250, 275
Assistant to the Regional Manager, IBM, Scranton, PA, 10, 15
Lead Guitarist, Philharmonic, Woodstock, NY, 100, 200
```

### Expected Output

```
All Opportunities
Title: Assistant to the Regional Manager, Organization: IBM, Location: Scranton, PA, Pay: 10-15
Title: Associate Tattoo Artist, Organization: Tit 4 Tat, Location: Brooklyn, NY, Pay: 250-275
Title: Lead Chef, Organization: Chipotle, Location: Denver, CO, Pay: 10-15
Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
Title: Manager of Fun, Organization: IBM, Location: Albany, NY, Pay: 30-40
Title: Stunt Double, Organization: Equity, Location: Los Angeles, CA, Pay: 15-25
```

Iteration 2: NY Jobs
--------------------

- Filter by State

### Input

```
Lead Chef, Chipotle, Denver, CO, 10, 15
Stunt Double, Equity, Los Angeles, CA, 15, 25
Manager of Fun, IBM, Albany, NY, 30, 40
Associate Tattoo Artist, Tit 4 Tat, Brooklyn, NY, 250, 275
Assistant to the Regional Manager, IBM, Scranton, PA, 10, 15
Lead Guitarist, Philharmonic, Woodstock, NY, 100, 200
```

### Expected Output

```
All Opportunities
Title: Assistant to the Regional Manager, Organization: IBM, Location: Scranton, PA, Pay: 10-15
Title: Associate Tattoo Artist, Organization: Tit 4 Tat, Location: Brooklyn, NY, Pay: 250-275
Title: Lead Chef, Organization: Chipotle, Location: Denver, CO, Pay: 10-15
Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
Title: Manager of Fun, Organization: IBM, Location: Albany, NY, Pay: 30-40
Title: Stunt Double, Organization: Equity, Location: Los Angeles, CA, Pay: 15-25

New York Opportunities
Title: Associate Tattoo Artist, Organization: Tit 4 Tat, Location: Brooklyn, NY, Pay: 250-275
Title: Lead Guitarist, Organization: Philharmonic, Location: Woodstock, NY, Pay: 100-200
Title: Manager of Fun, Organization: IBM, Location: Albany, NY, Pay: 30-40
```

Iteration 3: Now with JSON!
---------------------------

- Process opportunities encoded in mixed CSV and JSON

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

### Expected Output

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
```

Iteration 4: Lead Jobs
----------------------

- Filter by arbitrary predicates

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

### Expected Output

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


[circleci-badge]: https://circleci.com/gh/jmromer/opportunities/tree/master
[circleci-svg]: https://circleci.com/gh/jmromer/opportunities/tree/master.svg?style=svg

