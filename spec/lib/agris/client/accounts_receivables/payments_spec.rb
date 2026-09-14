# frozen_string_literal: true
require 'spec_helper'

describe Agris::Client do
  def build_output_hash(document, status, rejects_xml)
    Hash.from_xml(
      '<results>' \
      "<result type=\"ACRR0\" document=\"#{document}\" " \
      "status=\"#{status}\">" \
      "<rejects>#{rejects_xml}</rejects>" \
      '</result></results>'
    )
  end

  def build_processed_response
    double(
      'response',
      output_hash: build_output_hash(
        '100R1795003', 'Processed', '<reject />'
      )
    )
  end

  def build_rejected_response
    double(
      'response',
      output_hash: build_output_hash(
        '100      03',
        'Rejected',
        '<reject code="Q" reason="RECEIPT NUMBER CANNOT BE BLANK FOR ' \
        'EXISTING PAYMENTS" /><reject />'
      )
    )
  end

  def build_client(response)
    request_instance = double('request', process_message: response)
    request_class = Class.new
    allow(request_class).to receive(:new).and_return(request_instance)

    context = Agris::Context.new(
      'http://test.local', '001', '', 'AgrisDB', 'bob', 'fred'
    )
    client = Agris::Client.new(
      context,
      Agris::Credentials::Anonymous.new,
      { request_type: request_class },
      dataset: '001'
    )

    [client, request_instance]
  end

  def captured_payload(request_instance)
    payload = nil
    expect(request_instance).to have_received(:process_message) do |*args|
      payload = args.last
    end
    payload
  end

  def receive_attributes
    {
      bank_code: '03',
      cash_source: 'R',
      check_number: '000123456',
      discount_amount: '0.00',
      name_id: '1000676-01',
      payment_amount: '150.00',
      payment_date: '260827',
      receipt_location: '100'
    }
  end

  describe '#create_payment' do
    it 'targets the Agris import message' do
      # Arrange
      client, request_instance = build_client(build_processed_response)
      payment = Agris::Api::AccountsReceivables::NewPayment
                .receive(receive_attributes)

      # Act
      client.create_payment(payment)

      # Assert
      expect(request_instance).to have_received(:process_message)
        .with(anything, 82_320, anything)
    end

    it 'posts an unapplied receipt with no invoice or applied date' do
      # Arrange
      client, request_instance = build_client(build_processed_response)
      payment = Agris::Api::AccountsReceivables::NewPayment
                .receive(receive_attributes)

      # Act
      client.create_payment(payment)

      # Assert
      payload = captured_payload(request_instance)
      expect(payload).to include('recordtype="ACRR0"')
      expect(payload).to include('applyreceiveonacct="0"')
      expect(payload).to include('applieddate=""')
      expect(payload).to include('invoicelinepricingno=""')
      expect(payload.scan(%r{<detail[\s/]}).length).to eq(1)
    end

    it 'exposes the receipt Agris allocated' do
      # Arrange
      client, _request_instance = build_client(build_processed_response)
      payment = Agris::Api::AccountsReceivables::NewPayment
                .receive(receive_attributes)

      # Act
      result = client.create_payment(payment)

      # Assert
      expect(result.receipt_location).to eq('100')
      expect(result.receipt_number).to eq('R17950')
      expect(result.bank_code).to eq('03')
      expect(result).to be_allocated
    end

    it 'reports the rejection reason when Agris rejects the post' do
      # Arrange
      client, _request_instance = build_client(build_rejected_response)
      payment = Agris::Api::AccountsReceivables::NewPayment
                .receive(receive_attributes)

      # Act
      result = client.create_payment(payment)

      # Assert
      expect(result.status).to eq('Rejected')
      expect(result.reject_reasons).to eq(
        ['RECEIPT NUMBER CANNOT BE BLANK FOR EXISTING PAYMENTS']
      )
      expect(result).not_to be_allocated
    end

    it 'posts an attached remark alongside the receipt' do
      # Arrange
      client, request_instance = build_client(build_processed_response)
      payment = Agris::Api::AccountsReceivables::NewPayment
                .receive(receive_attributes)
      payment.add_remark(
        Agris::Api::AccountsReceivables::NewPaymentRemark.new(
          remark_number: '01',
          remark_value: 'IR-PAYMENT-99887766'
        )
      )

      # Act
      client.create_payment(payment)

      # Assert
      payload = captured_payload(request_instance)
      expect(payload).to include('recordtype="ACRR1"')
      expect(payload).to include('remarkvalue="IR-PAYMENT-99887766"')
      expect(payload.scan(%r{<detail[\s/]}).length).to eq(2)
    end
  end

  describe '#apply_payment' do
    it 'applies to the invoice against the allocated receipt' do
      # Arrange
      client, request_instance = build_client(build_processed_response)
      allocation = double(
        'allocation',
        bank_code: '03',
        receipt_location: '100',
        receipt_number: 'R17950'
      )
      payment = Agris::Api::AccountsReceivables::NewPayment.apply(
        receive_attributes.merge(
          applied_date: '260827',
          invoice_location: '100',
          invoice_line_pricing_no: 'D0485101001'
        )
      )

      # Act
      client.apply_payment(payment, allocation)

      # Assert
      payload = captured_payload(request_instance)
      expect(payload).to include('applyreceiveonacct="E"')
      expect(payload).to include('receiptnumber="R17950"')
      expect(payload).to include('receiptlocation="100"')
      expect(payload).to include('bankcode="03"')
      expect(payload).to include('invoicelinepricingno="D0485101001"')
      expect(payload).to include('applieddate="260827"')
    end

    it 'accepts the result of the receipt post as the allocation' do
      # Arrange
      client, request_instance = build_client(build_processed_response)
      allocation = Agris::Api::AccountsReceivables::PaymentPostResult
                   .new(build_processed_response)
      payment = Agris::Api::AccountsReceivables::NewPayment.apply(
        receive_attributes.merge(
          applied_date: '260827',
          invoice_line_pricing_no: 'D0485101001'
        )
      )

      # Act
      client.apply_payment(payment, allocation)

      # Assert
      payload = captured_payload(request_instance)
      expect(payload).to include('receiptnumber="R17950"')
    end
  end
end
