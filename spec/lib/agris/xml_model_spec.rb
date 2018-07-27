# frozen_string_literal: true
require "spec_helper"

describe Agris::XmlModel do
  class TestModel
    include Agris::XmlModel

    ATTRIBUTE_NAMES = %w(
      included_attribute
    ).freeze

    attr_accessor(*ATTRIBUTE_NAMES)

    def excluded_attribute; end

    def xml_ignore_attributes
      [:excluded_attribute]
    end
  end

  describe "#to_xml_hash" do
    let(:instance) do
      TestModel.new(
        excluded_attribute: "Excluded",
        included_attribute: "Included"
      )
    end

    subject { instance.to_xml_hash }

    it "should not include xml_ignored_attributes" do
      expect(subject).to include(:@includedattribute)
      expect(subject).to_not include(:@excludedattribute)
    end
  end
end
