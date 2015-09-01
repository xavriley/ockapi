# Ockapi - An Unofficial OpenCorporates Ruby Client

## Warning: Pre-pre-alpha. Don't use in production yet.

There is a lot of data on OpenCorporates. I found in my own projects that
I was doing similar tasks over and over again so I've made a gem to make it
easier to research companies and officers.

## Why Ockapi?

I wanted to call it [Okapi after the Congolese relative of the giraffe](https://en.wikipedia.org/?title=Okapi)
but believe it or not, that gem name is taken. Thus Ockapi. (You could read it as "an Ok version of the OpenCorporates (OC) api")

## Requirements

* Redis
* An OpenCorporates API key (free)
* A Companies House Beta API key (free)

## Getting started

To take advantage of caching API queries, you'll need Redis installed and running.
On a Mac its something like this:

```
$ brew install redis
$ redis-server /usr/local/etc/redis.conf
```

To start a session
```
$ git clone ...
$ bundle install
$ COMPANIES_HOUSE_TOKEN="yourCHtokenhere" OPENC_API_TOKEN="yourtokenhere" ./bin/ockapi
```

That opens a Pry console. Take it for a spin.

```ruby
# Search for several companies
> Company.search(name: "Boots Propco", jurisdiction_code: "gb")
Found 19 companies
=> [#<Company name="ALLIANCE BOOTS PROPCO A LLP", company_number="OC331120", jurisdiction_code="gb", incorporation_date="2007-09-05", dissolution_date=nil, company_type="Limited Liability Partnership", registry_url="http://data.companieshouse.gov.uk/doc/company/OC331120", branch_status=nil, inactive=false, current_status="Active", created_at="2010-10-21T14:14:35+00:00", updated_at="2015-06-06T13:32:36+00:00", retrieved_at="2015-06-01T00:00:00+00:00", opencorporates_url="https://opencorporates.com/companies/gb/OC331120", previous_names=[], source=[#<Representation publisher="UK Companies House", url="http://xmlgw.companieshouse.gov.uk/", terms="UK Crown Copyright", retrieved_at="2015-06-01T00:00:00+00:00">], registered_address_in_full="SEDLEY PLACE 4TH FLOOR, 361 OXFORD STREET, LONDON, W1C 2JL">,
 #<Company name="ALLIANCE BOOTS PROPCO B LLP", company_number="OC331121", jurisdiction_code="gb", incorporation_date="2007-09-05", dissolution_date=nil, company_type="Limited Liability Partnership", registry_url="http://data.companieshouse.gov.uk/doc/company/OC331121", branch_status=nil, inactive=false, current_status="Active", created_at="2010-10-21T14:14:35+00:00", updated_at="2015-06-06T13:32:36+00:00", retrieved_at="2015-06-01T00:00:00+00:00", opencorporates_url="https://opencorporates.com/companies/gb/OC331121", previous_names=[], source=[#<Representation publisher="UK Companies House", url="http://xmlgw.companieshouse.gov.uk/", terms="UK Crown Copyright", retrieved_at="2015-06-01T00:00:00+00:00">], registered_address_in_full="SEDLEY PLACE 4TH FLOOR, 361 OXFORD STREET, LONDON, W1C 2JL">,
 ...
 ]
```

Let's try dealing with some [Messi data](https://www.globalwitness.org/archive/messis-alleged-tax-evasion-scheme-relied-hiding-owners-uk-and-other-companies/)
```ruby
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

# You need to have pdfimages (brew install poppler) and tesseract installed
# for this next one to work, and sign up for a Companies House Beta API key
#
# Get the text of their latest annual return
> sidefloor.filings.sort_by {|x| Date.parse(x.date) }.reverse.detect {|x| x.title[/annual return/i] }.get_companies_house_doc
I, [2015-07-07T09:26:57.407564 #56783]  INFO -- : [HTTPCache]: Storing good response in cache for https://api.companieshouse.gov.uk/company/06087729/filing-history - "62e6f115dac9d14f09933b8c54fc28fe"
I, [2015-07-07T09:26:57.409218 #56783]  INFO -- : [HTTPCache]: Caching off for https://document-api.companieshouse.gov.uk/document/20RR4YVpG05LHXqBkNOQEBN3_S1Ij1Wg40VANvV1znU - "941f145143a3a3c06f832e94810edaf5"
I, [2015-07-07T09:26:57.654937 #56783]  INFO -- : [HTTPCache]: Caching off for https://document-api.companieshouse.gov.uk/document/20RR4YVpG05LHXqBkNOQEBN3_S1Ij1Wg40VANvV1znU/content - "84fbad264983fd4576049426a181f282"
Syntax Error (3365): Command token too long
Syntax Error (3493): Command token too long
Syntax Error (3621): Command token too long
Warning in pixReadMemPnm: work-around: writing to a temp file
Warning in pixReadMemPnm: work-around: writing to a temp file
Warning in pixReadMemPnm: work-around: writing to a temp file
Warning in pixReadMemPnm: work-around: writing to a temp file
Warning in pixReadMemPnm: work-around: writing to a temp file
=> ["Companies House\n\nARO\n\n1 (61)\n\n \n\nAnnual Return\n\n \n\n \n\n \n\n \n\n \n\n \n\n \n\n \n\n \n\n \n\n \n\n \n\n \n\n \n\n \n\nReceived for ﬁling in Electronic Format on the: 06/08/2014 X3DP36ET\nCompany Name: Sidefloor Limited\nCompany Number: 06087729\n\nDate of this return:\n\nSIC codes:\n\nCompany Type:\n\nSituation of Registered\nOﬁice:\n\n06/08/2014\n\n93199\n\nPrivate company limited by shares\n\n20—22 BEDFORD ROW\nLONDON\n\nUNITED KINGDOM\nWC 1R 4J S\n\nOfﬁcers of the company\n\nElectronically Filed Document for Company Number: 06087729\n\nPage: 1\n\n",
 "Company Secretary 1\n\nType: Corporate\nName: JORDAN COSEC LIMITED\nRegistered or\nprincipal address: 21 ST THOMAS STREET\nBRISTOL\nUNITED KINGDOM\nBS1 (U S\n\nEuropean Economic Area (EEA) Company\n\nRegister Location: ENGLAND & WALES\nRegistration Number: 06412777\n\nElectronically Filed Document for Company Number: 06087729 Page:2\n\n",
 "Company Director 1\n\nType: Person\n\nFull forename(s) : MR AYOMIDE\n\nSurname: OTUBANJO\n\nFormer names:\n\nService Address: 85—87 BAYHAM STREET\nLONDON\nUNITED KINGDOM\nNW 1 0AG\n\nCountry/State Usually Resident: UNITED KINGDOM\n\nDate of Birth: 06/08/1963 Nationality: BRITISH\nOccupation: CHARTERED CERTIFIED\nACCOUNTANT\n\nElectronically Filed Document for Company Number: 06087729 Page:3\n\n",
 "Statement of Capital (Share Capital)\n\nClass of shares ORDINARY Number allotted 1\nAggregate nominal 1\nCurrency GBP value\n\nAmount paid per share 0\n\nAmount unpaid per share 1\n\nPrescribed particulars\n\nVOTING RIGHTS SHARES RANK EQUALLY FOR VOTING PURPOSES. ON A SHOW OF HANDS EACH MEMBER\nSHALL HAVE ONE VOTE AND ON A POLL EACH MEMBER SHALL HAVE ONE VOTE PER SHARE HELD.\nDIVIDEND RIGHTS EACH SHARE RANKS EQUALLY FOR ANY DIVIDEND DECLARED. DISTRIBUTION RIGHTS\nON A WINDING UP EACH SHARE RANKS EQUALLY FOR ANY DISTRIBUTION MADE ON A WINDING UP.\nREDEEMABLE SHARES THE SHARES ARE NOT REDEEMABLE.\n\nStatement of Capital (Totals)\n\nCurrency GBP Total number\nof shares\n\nTotal aggregate\nnominal value\n\nFull Details of Shareholders\n\nThe details below relate to individuals / corporate bodies that were shareholders as at 06/08/2014\nor that had ceased to be shareholders since the made up date of the previous Annual Return\n\nA full list of shareholders for the company are shown below\n\n \n\nShareholding I ; 0 ORDIVARY shares held as at the date of this return\nName: BEDFORD NO.3 LIMITED\n\nShareholding 2 ; 0 ORDIVARY shares held as at the date of this return\nName: BEDFORD NOMINEES (UK) LTD.\n\nShareholding 3 ; 1 ORDIVARY shares held as at the date of this return\nName: ECCLESTARN LTD\n\nShareholding 4 ; 0 ORDIVARY shares held as at the date of this return\nName: INSTANT COMPANIES LIMITED\n\nShareholding 5 ; 0 ORDIVARY shares held as at the date of this return\nName: MR AYOMIDE OTUBANJO\n\nElectronically Filed Document for Company Number: 06087729 Page-4\n\n",
 "Authorisation\nAuthenticated\n\nThis form was authorised by one of the following:\n\nDirector, Secretary, Person Authorised, Charity Commission Receiver and Manager, CIC Manager, Judicial Factor.\n\nEnd of Electronically Filed Document for Company Number: 06087729 Page:5\n\n"]
```

## Some features/todos

I'm beginning to think this should be split into two gems, or a wrapper of two gems. One for the OpenCorporates API and one for the beta.companieshouse.gov.uk API.

#### Technical
- [x] Basic caching with HTTParty + CacheBar
- [x] Namespace everything to Ockapi
- [x] Package gem
- [x] Add tests!
- [x] Add representation classes for other "objects"
- [x] OCR filings with tesseract
- [ ] Make a proper REPL with help messages, documentation and everything
- [ ] Add specs for Company.search
- [ ] Make sure Company.search returns all results - `Company.search(name: "Central", registered_address_in_full: "S43 4PZ")`
- [ ] Add parameters for cache control
- [ ] Return results as ResultsSet object
- [ ] Release gem
- [ ] Parallelize queries with Typhoeus [see here](https://github.com/xavriley/cosy-companies/blob/master/app.rb#L144)

#### Practical
- [x] Group on postcode
- [x] Group on officer
- [ ] Group on industry codes
- [x] Retrieve filings from beta.companieshouse.gov.uk
- [ ] Add `latest_annual_report` method - `travelandevents.filings.select {|x| x.title[/annual accounts/i] }.first.get_companies_house_doc.join("\n")`
- [ ] Feedback on API usage limits
- [ ] Add `to_csv` on ResultsSet objects - `CSV::Table.new(results_set.map {|x| CSV::Row.new(x.to_h.keys, x.to_h.values) }).to_csv`
- [ ] Entity extraction on OCRed filings
- [ ] Parser/regex on OCRed filings
- [ ] Offer XBRL where available

## Credits

### Based on RubyConf 2014 - Rapidly Mapping JSON/XML API Schemas In Ruby

Speaker Deck: https://speakerdeck.com/acuppy/xml-apis-in-ruby

### References

Representable:

https://github.com/apotonick/representable

DeepStruct patterns:

http://andreapavoni.com/blog/2013/4/create-recursive-openstruct-from-a-ruby-hash/#.VGkqY5PF8Wk

Original code Authored by Adam Cuppy (@acuppy) of Coding ZEAL (http://codingzeal.com)
