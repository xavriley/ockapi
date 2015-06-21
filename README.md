# Okapi - An Unofficial OpenCorporates Ruby Client

## Warning: Pre-pre-alpha. Almost nothing works.

There is a lot of data on OpenCorporates. I found in my own projects that
I was doing similar tasks over and over again so I've made a gem to make it
easier to research companies and officers.

To start a session
```
$ git clone ...
$ bundle install
$ cd lib
$ OPENC_API_TOKEN="yourtokenhere" ruby example.rb
```

That opens a Pry console. Take it for a spin.

```ruby
# Search for groups
> Company.search(name: "Boots Propco", jurisdiction_code: "gb")
Found 19 companies
=> [#<Company name="ALLIANCE BOOTS PROPCO A LLP", company_number="OC331120", jurisdiction_code="gb", incorporation_date="2007-09-05", dissolution_date=nil, company_type="Limited Liability Partnership", registry_url="http://data.companieshouse.gov.uk/doc/company/OC331120", branch_status=nil, inactive=false, current_status="Active", created_at="2010-10-21T14:14:35+00:00", updated_at="2015-06-06T13:32:36+00:00", retrieved_at="2015-06-01T00:00:00+00:00", opencorporates_url="https://opencorporates.com/companies/gb/OC331120", previous_names=[], source=[#<Representation publisher="UK Companies House", url="http://xmlgw.companieshouse.gov.uk/", terms="UK Crown Copyright", retrieved_at="2015-06-01T00:00:00+00:00">], registered_address_in_full="SEDLEY PLACE 4TH FLOOR, 361 OXFORD STREET, LONDON, W1C 2JL">,
 #<Company name="ALLIANCE BOOTS PROPCO B LLP", company_number="OC331121", jurisdiction_code="gb", incorporation_date="2007-09-05", dissolution_date=nil, company_type="Limited Liability Partnership", registry_url="http://data.companieshouse.gov.uk/doc/company/OC331121", branch_status=nil, inactive=false, current_status="Active", created_at="2010-10-21T14:14:35+00:00", updated_at="2015-06-06T13:32:36+00:00", retrieved_at="2015-06-01T00:00:00+00:00", opencorporates_url="https://opencorporates.com/companies/gb/OC331121", previous_names=[], source=[#<Representation publisher="UK Companies House", url="http://xmlgw.companieshouse.gov.uk/", terms="UK Crown Copyright", retrieved_at="2015-06-01T00:00:00+00:00">], registered_address_in_full="SEDLEY PLACE 4TH FLOOR, 361 OXFORD STREET, LONDON, W1C 2JL">,
 ...
 ]

# Find individual companies by jurisdiction code and company number
> sidefloor = Company.find("gb", "06087729")
=> #<Company name="SIDEFLOOR LIMITED", company_number="06087729", jurisdiction_code="gb", incorporation_date="2007-02-07", dissolution_date=nil, company_type="Private Limited Company", registry_url="http://data.companieshouse.gov.uk/doc
/company/06087729", branch_status=nil, inactive=false, current_status="Active", created_at="2010-10-23T07:29:07+00:00", updated_at="2015-06-16T18:26:31+00:00", retrieved_at="2015-06-01T00:00:00+00:00", opencorporates_url="https://openco
rporates.com/companies/gb/06087729", source=[#<Representation publisher="UK Companies House", url="http://xmlgw.companieshouse.gov.uk/", terms="UK Crown Copyright", retrieved_at="2015-06-01T00:00:00+00:00">], agent_name=nil, agent_addre
ss=nil, registered_address_in_full="20-22 BEDFORD ROW, LONDON, WC1R 4JS", alternative_names=[], ... >

> sidefloor.officers
=> [#<Officer id=46371996, name="DAVID WILLIAM WAYGOOD", position="director", uid=nil, start_date="2007-03-20", end_date="2013-04-27", opencorporates_url="https://opencorporates.com/officers/46371996">,
 #<Officer id=71944809, name="AYOMIDE OTUBANJO", position="director", uid=nil, start_date="2013-05-28", end_date=nil, opencorporates_url="https://opencorporates.com/officers/71944809">,
 #<Officer id=99911676, name=" JORDAN COSEC LIMITED", position="secretary", uid=nil, start_date="2009-02-02", end_date=nil, opencorporates_url="https://opencorporates.com/officers/99911676">,
 #<Officer id=99911677, name=" JORDAN COMPANY SECRETARIES LIMITED", position="secretary", uid=nil, start_date="2007-03-20", end_date="2009-02-02", opencorporates_url="https://opencorporates.com/officers/99911677">,
 #<Officer id=99911678, name=" SWIFT INCORPORATIONS LIMITED", position="nominated secretary", uid=nil, start_date="2007-02-07", end_date="2007-03-23", opencorporates_url="https://opencorporates.com/officers/99911678">,
 #<Officer id=99911679, name=" INSTANT COMPANIES LIMITED", position="nominated director", uid=nil, start_date="2007-02-07", end_date="2007-03-23", opencorporates_url="https://opencorporates.com/officers/99911679">]

# Companies that this officer is also a director of
> sidefloor.officers.first.related_companies.length
=> 94
```

## Some features/todos

#### Technical
- [x] Basic caching with HTTParty + CacheBar
- [ ] package and release gem
- [ ] Add tests!
- [ ] OCR filings with tesseract
- [ ] Parallelize queries with Typhoeus [see here](https://github.com/xavriley/cosy-companies/blob/master/app.rb#L144)
- [ ] Add parameters for cache control
- [ ] Add representation classes for other "objects"

#### Practical
- [x] Group on postcode
- [x] Group on officer
- [ ] Group on industry codes
- [ ] Retrieve filings from beta.companieshouse.gov.uk
- [ ] Entity extraction on OCRed filings
- [ ] Feedback on API usage limits

## Credits

### Based on RubyConf 2014 - Rapidly Mapping JSON/XML API Schemas In Ruby

Speaker Deck: https://speakerdeck.com/acuppy/xml-apis-in-ruby

### References

Representable:

https://github.com/apotonick/representable

DeepStruct patterns:

http://andreapavoni.com/blog/2013/4/create-recursive-openstruct-from-a-ruby-hash/#.VGkqY5PF8Wk

Original code Authored by Adam Cuppy (@acuppy) of Coding ZEAL (http://codingzeal.com)
