require "spec_helper"

describe Ockapi::Representer do
  let(:type) { "companys" }
  let(:value) do
    {
      "id" => "1000",
      "name" => "Important Name",
      "electionDay" => "2020-01-01"
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
    end

    context "when representation doesn't exist" do
      let(:type) { "cats" }
      it { expect(subject.length).to be 1 }
      it { expect(subject.first).to be_a_kind_of Cat }
    end
  end
end
