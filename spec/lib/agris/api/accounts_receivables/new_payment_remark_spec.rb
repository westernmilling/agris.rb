# frozen_string_literal: true
require 'spec_helper'

describe Agris::Api::AccountsReceivables::NewPaymentRemark do
  describe '#initialize' do
    it 'stamps the ACRR1 record type' do
      # Arrange
      attributes = { record_type: 'OTHER' }

      # Act
      remark = described_class.new(attributes)

      # Assert
      expect(remark.record_type).to eq('ACRR1')
    end
  end

  describe '#to_xml_hash' do
    it 'maps every attribute onto its Agris field name' do
      # Arrange
      attributes = {
        bank_code: '03',
        receipt_location: '100',
        receipt_number: 'R17950',
        remark_number: '01',
        remark_value: 'IR-PAYMENT-99887766'
      }

      # Act
      hash = described_class.new(attributes).to_xml_hash

      # Assert
      expect(hash).to eq(
        :@bankcode => '03',
        :@receiptlocation => '100',
        :@receiptnumber => 'R17950',
        :@recordtype => 'ACRR1',
        :@remarknumber => '01',
        :@remarkvalue => 'IR-PAYMENT-99887766'
      )
    end
  end

  describe '#for_allocation' do
    it 'stamps the receipt Agris allocated onto the remark' do
      # Arrange
      remark = described_class.new(
        remark_number: '01',
        remark_value: 'IR-PAYMENT-99887766'
      )
      allocation = double(
        'allocation',
        bank_code: '03',
        receipt_location: '100',
        receipt_number: 'R17950'
      )

      # Act
      allocated = remark.for_allocation(allocation)

      # Assert
      expect(allocated.bank_code).to eq('03')
      expect(allocated.receipt_location).to eq('100')
      expect(allocated.receipt_number).to eq('R17950')
      expect(allocated.remark_value).to eq('IR-PAYMENT-99887766')
    end
  end
end
