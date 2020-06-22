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
    let(:invoice_number) { 'D04851' }
    let(:invoice_location) { '031' }
    let(:invoice_date) { '200401' }
    let(:original_date) { '200401' }
    let(:due_date) { '200517' }
    let(:general_ledger_details) do
      [
        {
          recordtype: 'ACRI2',
          glaccountmaincode: '43305',
          glaccountdetailcode: 'WC',
          distributionamount: '45.00'
        },
        {
          recordtype: 'ACRI2',
          glaccountmaincode: '43305',
          glaccountdetailcode: 'WC',
          distributionamount: '55.00'

        },
        {
          recordtype: 'ACRI2',
          glaccountmaincode: '43305',
          glaccountdetailcode: 'WC',
          distributionamount: '50.00'

        }
      ]
    end
    let(:line_items) do
      [

        created_by: '101',
        created_date: '2017-05-09T14:39:54.227Z',
        last_updated_by: '101',
        last_updated_date: '2019-01-19T19:56:07.093Z',
        location_code: invoice_location,
        line_item_no: '01',
        unit_price: 0.0,
        total_price: 0.0

      ]
    end

    let(:new_invoice_values) do
      ::Agris::Api::AccountsReceivables::Invoice.new(
        invoice_location: invoice_location,
        invoice_no: invoice_number,
        invoice_desc: "invoice #{invoice_number}",
        bill_to_id: '1000676-01',
        doc_type: '2',
        invoice_date: invoice_date,
        ship_date: invoice_date,
        line_items: line_items,
        invoice_amount: '150.00',
        general_ledger_details: general_ledger_details,
        original_date: original_date,
        due_date: due_date
      ).tap do |invoice|
        invoice.hash[:general_ledger_details].map do |gl|
          detail =
            ::Agris::Api::AccountsReceivables::Invoice::GeneralLedgerDetail.new(
              recordtype: 'ACRI2',
              glaccountmaincode: gl[:glaccountmaincode],
              glaccountdetailcode: gl[:glaccountdetailcode],
              distributionamount: gl[:distributionamount]
            )
          invoice.add_general_ledger_detail(detail)
        end
        invoice.hash[:line_items].map do |li|
          line_item =
            ::Agris::Api::AccountsReceivables::Invoice::LineItem.new(
              created_by: li[:created_by],
              created_date: li[:created_date],
              last_updated_by: li[:last_updated_by],
              last_updated_date: li[:last_updated_date],
              location_code: li[:location_code],
              line_item_no: li[:line_item_no],
              unit_price: li[:unit_price],
              total_price: li[:total_price]
            )
          invoice.add_line_item(line_item)
        end
        @invoice = invoice.hash
      end

      @invoice
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
