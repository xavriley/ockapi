require "spec_helper"

describe Ockapi::Representer do
  let(:type) { "companys" }
  let(:value) do
    {
      "id" => "1000",
      "name" => "Important Name",
      "officers" => [{"officer" => {name: "John Smith", dob: "01/01/1900"}}],
      "filings" => [],
      "source" => {}
    }
  end
  let(:parent) { nil }

  subject(:representer) do
    Ockapi::Representer.new(type: type, value: value, parent: parent)
  end

  describe "#represent" do
    subject { representer.represent }

    context "when parent exists" do
      let(:parent) { Ockapi::Representation.new }
      it { expect(subject.first.parent).to eq parent }
    end

    context "when parent doesn't exist" do
      it { expect(subject.first.parent).to be_nil }
    end

    context "when representation exists" do
      it { expect(subject.length).to be 1 }
      it { expect(subject.first).to be_a_kind_of Ockapi::Company }

      it "handles nested representations" do
        expect(subject.first.officers.first).to be_a_kind_of Officer
      end

      it "handles empty collections" do
        expect(subject.first.filings).to be_empty
      end

      it "handles empty objects" do
        expect(subject.first.source).to be_empty
      end
    end

    context "when representation doesn't exist" do
      let(:type) { "cats" }
      it { expect(subject.length).to be 1 }
      it { expect(subject.first).to be_a_kind_of Cat }
    end
  end
end
