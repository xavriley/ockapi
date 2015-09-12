require "spec_helper"

describe Ockapi::Company do
  it "should search all the companies" do
    VCR.use_cassette("company_search") do
      expect(Ockapi::Company.search({name: "Central", registered_address_in_full: "S43 4PZ"}, {limit: 2000}).count).to eq(1599)
    end

  end
  it "reconciles a company name" do
    VCR.use_cassette("company_reconciliation") do
      VCR.use_cassette("retrieve_reconciled_company") do
        expect(Ockapi::Company.reconcile("Sidefloor Limited").company_number).to eq("06087729")
      end
    end
  end
end
