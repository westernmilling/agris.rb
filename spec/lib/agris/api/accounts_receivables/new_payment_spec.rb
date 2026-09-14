# frozen_string_literal: true
require 'spec_helper'

describe Agris::Api::AccountsReceivables::NewPayment do
  def receipt_attributes
    {
      bank_code: '03',
      cash_source: 'R',
      check_number: '000123456',
      discount_amount: '0.00',
      invoice_location: '100',
      name_id: '1000676-01',
      payment_amount: '150.00',
      payment_date: '260827',
      receipt_location: '100'
    }
  end

  def build_allocation
    double(
      'allocation',
      bank_code: '03',
      receipt_location: '100',
      receipt_number: 'R17950'
    )
  end

  describe '#initialize' do
    it 'stamps the ACRR0 record type' do
      # Arrange
      attributes = { record_type: 'OTHER' }

      # Act
      payment = described_class.new(attributes)

      # Assert
      expect(payment.record_type).to eq('ACRR0')
    end

    it 'assigns the caller-supplied attributes' do
      # Arrange
      attributes = receipt_attributes

      # Act
      payment = described_class.new(attributes)

      # Assert
      expect(payment.bank_code).to eq('03')
      expect(payment.name_id).to eq('1000676-01')
      expect(payment.payment_amount).to eq('150.00')
      expect(payment.receipt_location).to eq('100')
    end
  end

  describe '.receive' do
    it 'does not apply the receipt to an invoice' do
      # Arrange
      attributes = receipt_attributes

      # Act
      payment = described_class.receive(attributes)

      # Assert
      expect(payment.apply_receive_on_acct).to eq('0')
    end

    it 'blanks the applied date and the invoice' do
      # Arrange
      attributes = receipt_attributes.merge(
        applied_date: '260827',
        invoice_line_pricing_no: 'D0485101001'
      )

      # Act
      payment = described_class.receive(attributes)

      # Assert
      expect(payment.applied_date).to eq('')
      expect(payment.invoice_line_pricing_no).to eq('')
    end
  end

  describe '.apply' do
    it 'applies against an existing payment' do
      # Arrange
      attributes = receipt_attributes.merge(
        applied_date: '260827',
        invoice_line_pricing_no: 'D0485101001',
        receipt_number: 'R17950'
      )

      # Act
      payment = described_class.apply(attributes)

      # Assert
      expect(payment.apply_receive_on_acct).to eq('E')
      expect(payment.applied_date).to eq('260827')
      expect(payment.invoice_line_pricing_no).to eq('D0485101001')
      expect(payment.receipt_number).to eq('R17950')
    end
  end

  describe '#to_xml_hash' do
    it 'maps every attribute onto its Agris field name' do
      # Arrange
      attributes = receipt_attributes.merge(
        applied_date: '260827',
        invoice_line_pricing_no: 'D0485101001',
        receipt_number: 'R17950'
      )

      # Act
      hash = described_class.apply(attributes).to_xml_hash

      # Assert
      expect(hash).to eq(
        :@applieddate => '260827',
        :@applyreceiveonacct => 'E',
        :@bankcode => '03',
        :@cashsource => 'R',
        :@checknumber => '000123456',
        :@discountamount => '0.00',
        :@invoicelinepricingno => 'D0485101001',
        :@invoicelocation => '100',
        :@nameid => '1000676-01',
        :@paymentamount => '150.00',
        :@paymentdate => '260827',
        :@receiptlocation => '100',
        :@receiptnumber => 'R17950',
        :@recordtype => 'ACRR0'
      )
    end

    it 'omits the attached remarks' do
      # Arrange
      payment = described_class.receive(receipt_attributes)
      payment.add_remark(
        Agris::Api::AccountsReceivables::NewPaymentRemark.new(
          remark_number: '01'
        )
      )

      # Act
      hash = payment.to_xml_hash

      # Assert
      expect(hash).not_to have_key(:@remarks)
    end
  end

  describe '#records' do
    it 'leads with the receipt itself' do
      # Arrange
      payment = described_class.receive(receipt_attributes)

      # Act
      records = payment.records

      # Assert
      expect(records).to eq([payment])
    end

    it 'follows the receipt with each attached remark' do
      # Arrange
      payment = described_class.receive(receipt_attributes)
      remark = Agris::Api::AccountsReceivables::NewPaymentRemark.new(
        remark_number: '01',
        remark_value: 'IR-PAYMENT-99887766'
      )
      payment.add_remark(remark)

      # Act
      records = payment.records

      # Assert
      expect(records).to eq([payment, remark])
    end
  end

  describe '#for_allocation' do
    it 'stamps the receipt Agris allocated onto the payment' do
      # Arrange
      payment = described_class.apply(
        receipt_attributes.merge(
          bank_code: nil,
          receipt_location: nil,
          invoice_line_pricing_no: 'D0485101001'
        )
      )

      # Act
      allocated = payment.for_allocation(build_allocation)

      # Assert
      expect(allocated.bank_code).to eq('03')
      expect(allocated.receipt_location).to eq('100')
      expect(allocated.receipt_number).to eq('R17950')
    end

    it 'preserves the attributes the caller supplied' do
      # Arrange
      payment = described_class.apply(
        receipt_attributes.merge(invoice_line_pricing_no: 'D0485101001')
      )

      # Act
      allocated = payment.for_allocation(build_allocation)

      # Assert
      expect(allocated.apply_receive_on_acct).to eq('E')
      expect(allocated.invoice_line_pricing_no).to eq('D0485101001')
      expect(allocated.payment_amount).to eq('150.00')
    end

    it 'stamps the receipt onto each attached remark' do
      # Arrange
      payment = described_class.apply(receipt_attributes)
      payment.add_remark(
        Agris::Api::AccountsReceivables::NewPaymentRemark.new(
          remark_number: '01',
          remark_value: 'IR-PAYMENT-99887766'
        )
      )

      # Act
      allocated = payment.for_allocation(build_allocation)

      # Assert
      expect(allocated.remarks.map(&:receipt_number)).to eq(['R17950'])
      expect(allocated.remarks.map(&:remark_value))
        .to eq(['IR-PAYMENT-99887766'])
    end

    it 'leaves the original payment untouched' do
      # Arrange
      payment = described_class.apply(
        receipt_attributes.merge(receipt_number: nil)
      )

      # Act
      payment.for_allocation(build_allocation)

      # Assert
      expect(payment.receipt_number).to be_nil
    end
  end
end
