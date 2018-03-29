# frozen_string_literal: true
require 'spec_helper'
require 'savon/mock/spec_helper'
require_relative '../shared_contexts'

describe Agris::Client, :agris_api_mock do
  include Savon::SpecHelper

  describe '#purchase_contract' do
    include_context 'test agris client'

    before do
      savon
        .expects(:process_message)
        .with(message: :any)
        .returns(response_body)
    end

    let(:response_body) do
      File.read(File.join(%W(./ spec fixtures agris #{fixture_file})))
    end

    context 'when a contract is found' do
      let(:fixture_file) { 'grain/purchase_contract_found_result.xml' }
      let(:contract_location) { 'ABC' }
      let(:contract_number) { '0000011' }

      it 'returns the contract' do
        result = client.purchase_contract(contract_location, contract_number)

        expect(result.documents.length).to eq(1)
        expect(result.documents[0].contract_number).to eq(contract_number)
      end
    end

    context 'when a contract is not found' do
      let(:fixture_file) { 'grain/purchase_contract_not_found_result.xml' }
      let(:contract_location) { 'ABC' }
      let(:contract_number) { '1' }

      it 'returns no contract' do
        result = client.purchase_contract(contract_location, contract_number)

        expect(result.documents.length).to eq(0)
      end
    end
  end
end
