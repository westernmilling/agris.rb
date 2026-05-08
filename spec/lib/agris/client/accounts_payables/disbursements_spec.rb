# frozen_string_literal: true
require 'spec_helper'

describe Agris::Client do
  describe '#create_disbursement' do
    def build_response_double
      double(
        'response',
        output_hash: {
          'results' => {
            'result' => {
              'status' => 'Processed',
              'document' => 'D000123',
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

    def build_disbursement
      Agris::Api::NewDisbursement.new(
        bank_code: 'WF',
        check_number: '0000123',
        name_id: 'V12345',
        payment_amount: '100.00',
        payment_date: '20260101',
        voucher_location: '001',
        voucher_number: '00012300000'
      )
    end

    def capture_args(target, method)
      captured = nil
      expect(target).to have_received(method) do |*args|
        captured = args
      end
      captured
    end

    it 'targets the Agris ProcessMessage id 82320' do
      # Arrange
      request_class, request_instance = build_request_class(build_response_double)
      client = build_client(request_class, build_context)
      disbursement = build_disbursement

      # Act
      client.create_disbursement(disbursement)

      # Assert
      expect(request_instance).to have_received(:process_message)
        .with(anything, 82_320, anything)
    end

    it 'sends a SOAP context payload built from the configured Context' do
      # Arrange
      request_class, request_instance = build_request_class(build_response_double)
      client = build_client(request_class, build_context)
      disbursement = build_disbursement

      # Act
      client.create_disbursement(disbursement)

      # Assert
      context_xml, _msg_id, _payload_xml =
        capture_args(request_instance, :process_message)
      expect(context_xml).to include('<login')
      expect(context_xml).to include('dataset="001"')
      expect(context_xml).to include('database="AgrisDB"')
      expect(context_xml).to include('userid="bob"')
    end

    it 'wraps the disbursement payload as a single-record details list' do
      # Arrange
      request_class, request_instance = build_request_class(build_response_double)
      client = build_client(request_class, build_context)
      disbursement = build_disbursement

      # Act
      client.create_disbursement(disbursement)

      # Assert
      _context_xml, _msg_id, payload_xml =
        capture_args(request_instance, :process_message)
      expect(payload_xml).to include('<details>')
      expect(payload_xml).to include('recordtype="ACPD0"')
      expect(payload_xml).to include('bankcode="WF"')
      expect(payload_xml).to include('vouchernumber="00012300000"')
      # Self-closing `<detail recordtype="..." .../>` because all attributes
      # are `@`-prefixed (Gyoku renders them as XML attributes, not children).
      expect(payload_xml.scan(%r{<detail[\s/]}).length).to eq(1)
    end

    it 'returns an Agris::Api::PostResult wrapping the SOAP response' do
      # Arrange
      request_class, _request_instance = build_request_class(build_response_double)
      client = build_client(request_class, build_context)
      disbursement = build_disbursement

      # Act
      result = client.create_disbursement(disbursement)

      # Assert
      expect(result).to be_a(Agris::Api::PostResult)
      expect(result.status).to eq('Processed')
      expect(result.document_number).to eq('D000123')
    end
  end
end
