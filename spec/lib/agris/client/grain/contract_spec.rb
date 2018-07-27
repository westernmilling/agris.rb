# frozen_string_literal: true
require 'spec_helper'
require 'savon/mock/spec_helper'
require_relative '../shared_contexts'

describe Agris::Api::Grain::Contract, :agris_api_mock do
  include Savon::SpecHelper

  describe '#from_json_hash' do
    let(:fixture_file) { 'grain/purchase_contract_one_result.json' }
    let(:response_body) do
      str = File.read(File.join(%W(./ spec fixtures agris #{fixture_file})))
      JSON.parse(str)
    end

    subject { Agris::Api::Grain::Contract.from_json_hash(response_body) }

    it 'should create contract' do
      expect(subject.contract_location).to eq('AZI')
      expect(subject.contract_number).to eq('S000510')
      expect(subject.commodity).to eq('CK')
      expect(subject.contract_quantity).to eq('50')
      expect(subject.contract_type).to eq('S')
      expect(subject.schedules[0].number).to eq('01')
      expect(subject.schedules[0].price_status).to eq('P')
      expect(subject.schedules[0].apply_status).to eq('F')
    end
  end
end
