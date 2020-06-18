# frozen_string_literal: true
require 'spec_helper'
require 'savon/mock/spec_helper'
require_relative '../shared_contexts'

describe Agris::Client, :agris_api_mock do
  include Savon::SpecHelper

  describe '#create_invoice' do
    include_context 'test agris client'

    before do
      savon
        .expects(:process_message)
        .with(message: :any)
        .returns(response_body)
    end

    let(:new_invoice_values) do
      {
        recordtype: 'ACRI0',
        invoicelocation: '073',
        invoiceno: 'D1462918-1',
        billtoid: '1000676-01',
        doctype: '2',
        invoicedate: '200130',
        shipdate: '200101',
        invoiceamount: '888.21',
        usrorderfield1: '12345'
      }
    end

    let(:new_invoice) do
      Agris::Api::AccountsReceivables::Invoice.new(new_invoice_values)
    end

    let(:response_body) do
      File.read(File.join(%W(./ spec fixtures agris #{fixture_file})))
    end

    context 'when the invoice is processed' do
      let(:fixture_file) { 'grain/import_invoice_processed.xml' }

      it 'should return a result with status of Processed' do
        result = client.create_invoice(new_invoice)

        expect(result.status).to eq 'Processed'
      end
    end

    context 'when the invoice is rejected' do
      let(:fixture_file) { 'grain/import_invoice_rejection.xml' }

      it 'should return a result with status of Rejected' do
        result = client.create_invoice(new_invoice)

        expect(result.status).to eq 'Rejected'
      end
    end
  end
end
