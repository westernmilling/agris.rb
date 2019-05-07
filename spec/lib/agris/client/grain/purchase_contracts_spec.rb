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
      let(:fixture_file) { 'grain/purchase_contract_one_result.xml' }
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

  describe '#purchase_contracts' do
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

    context 'when contracts are found' do
      let(:fixture_file) { 'grain/purchase_contract_two_results.xml' }
      let(:contract_location_1) { 'ABC' }
      let(:contract_number_1) { '0000011' }
      let(:contract_location_2) { 'ABC' }
      let(:contract_number_2) { '0000014' }

      let(:purchase_contract_extracts) do
        [
          Agris::Api::Grain::SpecificContractExtract
            .new(contract_location_1, contract_number_1),
          Agris::Api::Grain::SpecificContractExtract
            .new(contract_location_2, contract_number_2)
        ]
      end

      it 'returns the contracts' do
        result = client.purchase_contracts(purchase_contract_extracts)

        expect(result.documents.length).to eq(2)
        expect(result.documents[0].contract_number).to eq(contract_number_1)
        expect(result.documents[1].contract_number).to eq(contract_number_2)
        expect(result.documents[1].schedules[0].salesperson_code).to \
          eq('001')
      end
    end
  end

  describe '#purchase_contracts_changed_since' do
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
    let(:datetime) { Time.parse('2018-01-03T14:25:00)') }

    context 'when a contract is found' do
      let(:fixture_file) do
        'grain/purchase_contract_two_results_no_detail.xml'
      end
      let(:contract_number_1) { '0000001' }
      let(:contract_number_2) { '0000002' }

      it 'returns the contract' do
        result = client.purchase_contracts_changed_since(datetime)

        expect(result.documents.length).to eq(2)
        expect(result.documents[0].contract_number).to eq(contract_number_1)
        expect(result.documents[1].contract_number).to eq(contract_number_2)
      end
    end

    context 'when a contract is not found' do
      let(:fixture_file) { 'grain/purchase_contract_not_found_result.xml' }

      it 'returns no contract' do
        result = client.purchase_contracts_changed_since(datetime)

        expect(result.documents.length).to eq(0)
      end
    end
  end
end
