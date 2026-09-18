# frozen_string_literal: true
require 'spec_helper'

describe Agris::Client do
  describe '#create_voucher' do
    context 'with a general ledger detail and a freight ticket reference' do
      it 'posts the header and both details as sibling records' do
        # Arrange
        response = StubbedAgrisClient.processed_response('051032228')
        client, request = StubbedAgrisClient.stubbed_agris_client(response)
        payload_xml = nil

        # Act
        client.create_voucher(build(:new_voucher, :freight))

        # Assert
        expect(request).to have_received(:process_message) do |*args|
          payload_xml = args.last
        end
        expect(payload_xml.scan(/recordtype="(ACPV\d)"/).flatten)
          .to eq(%w(ACPV0 ACPV2 ACPV3))
        expect(payload_xml.scan(%r{<detail[\s/]}).length).to eq(3)
      end

      it 'carries the ticket reference attributes on the ACPV3 record' do
        # Arrange
        response = StubbedAgrisClient.processed_response('051032228')
        client, request = StubbedAgrisClient.stubbed_agris_client(response)
        payload_xml = nil

        # Act
        client.create_voucher(build(:new_voucher, :freight))

        # Assert
        expect(request).to have_received(:process_message) do |*args|
          payload_xml = args.last
        end
        ticket_record = payload_xml[/<detail[^>]*recordtype="ACPV3"[^>]*>/]
        expect(ticket_record).to include('inoutcode="I"')
        expect(ticket_record).to include('ticketlocation="051"')
        expect(ticket_record).to include('ticketnumber="0028786"')
        expect(ticket_record).to include('freightamount="230.85"')
      end

      it 'returns a processed PostResult with the voucher document number' do
        # Arrange
        response = StubbedAgrisClient.processed_response('051032228')
        client, _request = StubbedAgrisClient.stubbed_agris_client(response)

        # Act
        result = client.create_voucher(build(:new_voucher, :freight))

        # Assert
        expect(result).to be_a(Agris::Api::PostResult)
        expect(result.document_number).to eq('051032228')
      end
    end
  end
end
