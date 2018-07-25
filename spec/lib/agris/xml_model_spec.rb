# frozen_string_literal: true
require 'spec_helper'

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

  describe '#to_xml_hash' do
    let(:instance) do
      TestModel.new(
        excluded_attribute: 'Excluded',
        included_attribute: 'Included'
      )
    end

    subject { instance.to_xml_hash }

    it 'should not include xml_ignored_attributes' do
      expect(subject).to include(:@includedattribute)
      expect(subject).to_not include(:@excludedattribute)
    end
  end

  describe '#from_json_hash' do
    let(:fixture_file) { 'grain/purchase_contract_one_result.json' }
    let(:response_body) do
      str = File.read(File.join(%W(./ spec fixtures agris #{fixture_file})))
      JSON.parse(str)
    end

    subject { TestModel.from_json_hash(response_body) }

    it 'should not include xml_ignored_attributes' do
      expect(subject.hash['contract_location']).to eq('AZI')
      expect(subject.hash['contract_number']).to eq('S000510')
      expect(subject.hash['commodity']).to eq('CK')
      expect(subject.hash['contract_quantity']).to eq('50')
      expect(subject.hash['contract_type']).to eq('S')
    end
  end
end
