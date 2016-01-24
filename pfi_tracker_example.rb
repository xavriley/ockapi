require 'dotenv'
require 'launchy'
Dotenv.load
load './lib/ockapi.rb'

@companies = []
#company = "INFRASTRUCTURE INVESTMENTS (ROADS) LIMITED"
#company = "INFRARED (INFRASTRUCTURE) CAPITAL PARTNERS LIMITED"
start_company = "Consort Healthcare (Blackburn) Limited"
start_company = "CRITERION HEALTHCARE PLC"
start_company = "HPC BAS LIMITED"
start_company = "FORESIGHT VCT PLC"
start_company = "SUSSEX CUSTODIAL SERVICES (HOLDINGS) LIMITED"
start_company = "FAZAKERLEY PRISON SERVICES LIMITED"
start_company = "Stc (Milton Keynes) Limited"
start_company = "KEY HEALTH SERVICES (ADDENBROOKES) LIMITED"

def get_tree_for(company)
  parents = find_parents(company)

  [company, parents.map {|parent|
    [parent, get_tree_for(parent)]
  }]
end

def find_parents(company)
  puts company.name
  puts company.company_number
  ar = company.latest_annual_return(true)
  @companies << Ockapi::Company.new(company.instance_variable_get("@table").merge(ar.instance_variable_get("@table")))
  shareholder_statement = ar[:content].split(/full list of shareholders/i)
  companies = shareholder_statement.last.scan(/^\s*Name:\s*(.*)/)

  #return nil if companies.nil?

  companies = companies.map(&:first).map(&:strip)
  companies.reverse.map do |company|
    if company == "" or Ockapi::Company.reconcile(company).nil?
      `open -a Preview #{ar[:pdf_path]}`
      $stderr.puts "Shareholder info not found"
      $stderr.puts "Please enter the parent company name:"

      while(company != "quit" and (company == "" or Ockapi::Company.reconcile(company).nil?))
        company = gets.strip
      end
    end

    Ockapi::Company.reconcile(company)
  end
end

output = get_tree_for(Ockapi::Company.reconcile(start_company))

require 'csv'
csv = CSV::Table.new(@companies.map {|x| x.to_h }.map {|x| CSV::Row.new(x.keys, x.values) }).to_csv
File.open("/Users/xavierriley/Desktop/#{start_company}.csv", 'w') {|f| f.write csv }
