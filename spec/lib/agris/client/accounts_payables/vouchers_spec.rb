# frozen_string_literal: true
require 'spec_helper'

describe Agris::Client do
  describe '#create_voucher' do
    def build_response_double
      double(
        'response',
        output_hash: {
          'results' => {
            'result' => {
              'status' => 'Processed',
              'document' => '051032228',
              'rejects' => { 'reject' => [] }
            }
          }
        }
      )
    end

    def build_request_class(response_double)
      request_instance = double('request', process_message: response_double)
      klass = Class.new
      allow(klass).to receive(:new).and_return(request_instance)
      [klass, request_instance]
    end

    def build_context
      Agris::Context.new(
        'http://test.local',
        '001',
        '\\\\host\\datasets',
        'AgrisDB',
        'bob',
        'fred'
      )
    end

    def build_client(request_class, context)
      Agris::Client.new(
        context,
        Agris::Credentials::Anonymous.new,
        { request_type: request_class },
        dataset: '001'
      )
    end

    def build_freight_voucher
      voucher = Agris::Api::NewVoucher.new(
        doc_type: '2',
        remit_to_id: '1002424-00',
        shipper_id: '1002424-00',
        voucher_amount: '230.85',
        voucher_type: 'FV'
      )
      voucher.add_detail(
        Agris::Api::NewVoucher::GeneralLedgerDetail.new(
          distribution_amount: '230.85',
          gl_account_main_code: '48670',
          gl_account_detail_code: 'WN'
        )
      )
      voucher.add_detail(
        Agris::Api::NewVoucher::FreightTicketReferenceDetail.new(
          in_out_code: 'I',
          ticket_location: '051',
          ticket_number: '0028786',
          freight_amount: '230.85'
        )
      )
      voucher
    end

    def capture_payload_xml(request_instance)
      captured = nil
      expect(request_instance).to have_received(:process_message) do |*args|
        captured = args
      end
      captured.last
    end

    context 'with a general ledger detail and a freight ticket reference' do
      it 'posts the header and both details as sibling records' do
        # Arrange
        request_class, request_instance =
          build_request_class(build_response_double)
        client = build_client(request_class, build_context)

        # Act
        client.create_voucher(build_freight_voucher)

        # Assert
        payload_xml = capture_payload_xml(request_instance)
        record_types = payload_xml.scan(/recordtype="(ACPV\d)"/).flatten
        expect(record_types).to eq(%w(ACPV0 ACPV2 ACPV3))
        expect(payload_xml.scan(%r{<detail[\s/]}).length).to eq(3)
      end

      it 'carries the ticket reference attributes on the ACPV3 record' do
        # Arrange
        request_class, request_instance =
          build_request_class(build_response_double)
        client = build_client(request_class, build_context)

        # Act
        client.create_voucher(build_freight_voucher)

        # Assert
        payload_xml = capture_payload_xml(request_instance)
        ticket_record = payload_xml[/<detail[^>]*recordtype="ACPV3"[^>]*>/]
        expect(ticket_record).to include('inoutcode="I"')
        expect(ticket_record).to include('ticketlocation="051"')
        expect(ticket_record).to include('ticketnumber="0028786"')
        expect(ticket_record).to include('freightamount="230.85"')
      end

      it 'returns a processed PostResult with the voucher document number' do
        # Arrange
        request_class, _request_instance =
          build_request_class(build_response_double)
        client = build_client(request_class, build_context)

        # Act
        result = client.create_voucher(build_freight_voucher)

        # Assert
        expect(result).to be_a(Agris::Api::PostResult)
        expect(result.document_number).to eq('051032228')
      end
    end
  end
end
