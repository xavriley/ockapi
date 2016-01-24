require "spec_helper"

describe Ockapi::Company do
  it "can retrieve a Companies House document" do
    VCR.use_cassette("ch_document_retrieval") do
      test_co = Ockapi::Company.reconcile("SHEPPEY ROUTE LIMITED")
      expect(test_co.latest_annual_return).to be_a_kind_of(String)
    end
  end

  it "extracts a shareholder from the annual return" do
    VCR.use_cassette("find_shareholders", record: :new_episodes) do
      VCR.use_cassette("fetch_ch_reports", record: :new_episodes) do
        VCR.use_cassette("fetch_ch_reports_two", record: :new_episodes) do
          start_company = "INFRARED PARTNERS LLP"
          # start_company = "HSBC SPECIALIST INVESTMENTS LIMITED"
          # SEMPERIAN PPP INVESTMENT PARTNERS GROUP LIMITED breaks the latest_ar somehow

          while company = Ockapi::Company.reconcile(start_company)
            ar = company.latest_annual_return(true)
            shareholder_statement = ar[:content].split(/full list of shareholders/i)
            companies = shareholder_statement.last.scan(/^\s*Name:\s*(.*)/)
            companies = companies.map(&:first).map(&:strip)
            start_company = companies.first
            require 'pry'; binding.pry
          end

          expect(companies.length).to eq(1)
        end
      end
    end
  end
end
