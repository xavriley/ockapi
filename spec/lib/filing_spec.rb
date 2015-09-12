require "spec_helper"

describe Ockapi::Company do
  it "can retrieve a Companies House document" do
    VCR.use_cassette("ch_document_retrieval") do
      test_co = Ockapi::Company.reconcile("SHEPPEY ROUTE LIMITED")
      expect(test_co.latest_annual_return).to be_a_kind_of(String)
    end
  end
end
