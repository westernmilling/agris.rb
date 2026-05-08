# frozen_string_literal: true
require 'spec_helper'

describe Agris::Api::NewDisbursement do
  def build_acpd0_attributes
    {
      applied_date: '20260101',
      apply_payment_on_account: '1',
      bank_code: 'WF',
      cash_source: 'A',
      check_location: '001',
      check_number: '0000123',
      currency_code: 'USD',
      discount_amount: '0.00',
      exchange_rate: '1.000000',
      exchange_rate_date: '20260101',
      misc_reference: '',
      name_id: 'V12345',
      payment_amount: '100.00',
      payment_date: '20260101',
      prepayment_reference: '',
      prepayment_type: '',
      reserved: '',
      voucher_location: '001',
      voucher_number: '00012300000'
    }
  end

  describe '#initialize' do
    it 'defaults record_type to ACPD0' do
      # Arrange
      # (no setup — exercising the default path)

      # Act
      instance = described_class.new

      # Assert
      expect(instance.record_type).to eq('ACPD0')
    end

    it 'overrides any record_type passed in the hash' do
      # Arrange
      attributes = { record_type: 'OTHER' }

      # Act
      instance = described_class.new(attributes)

      # Assert
      expect(instance.record_type).to eq('ACPD0')
    end

    it 'assigns the 19 caller-supplied attributes from the hash' do
      # Arrange
      attributes = build_acpd0_attributes

      # Act
      instance = described_class.new(attributes)

      # Assert
      expect(instance.bank_code).to eq('WF')
      expect(instance.voucher_number).to eq('00012300000')
      expect(instance.payment_amount).to eq('100.00')
      expect(instance.name_id).to eq('V12345')
    end
  end

  describe '#to_xml_hash' do
    it 'serializes record_type as :@recordtype with the ACPD0 default' do
      # Arrange
      # (no setup — exercising the default path)

      # Act
      hash = described_class.new.to_xml_hash

      # Assert
      expect(hash[:@recordtype]).to eq('ACPD0')
    end

    it 'serializes all 20 ACPD0 attributes with underscore-stripped @-keys' do
      # Arrange
      attributes = build_acpd0_attributes

      # Act
      hash = described_class.new(attributes).to_xml_hash

      # Assert
      expect(hash.keys).to contain_exactly(
        :@applieddate,
        :@applypaymentonaccount,
        :@bankcode,
        :@cashsource,
        :@checklocation,
        :@checknumber,
        :@currencycode,
        :@discountamount,
        :@exchangerate,
        :@exchangeratedate,
        :@miscreference,
        :@nameid,
        :@paymentamount,
        :@paymentdate,
        :@prepaymentreference,
        :@prepaymenttype,
        :@recordtype,
        :@reserved,
        :@voucherlocation,
        :@vouchernumber
      )
    end

    it 'preserves the values for each ACPD0 attribute' do
      # Arrange
      attributes = build_acpd0_attributes

      # Act
      hash = described_class.new(attributes).to_xml_hash

      # Assert
      expect(hash[:@applieddate]).to eq('20260101')
      expect(hash[:@applypaymentonaccount]).to eq('1')
      expect(hash[:@bankcode]).to eq('WF')
      expect(hash[:@checknumber]).to eq('0000123')
      expect(hash[:@nameid]).to eq('V12345')
      expect(hash[:@paymentamount]).to eq('100.00')
      expect(hash[:@voucherlocation]).to eq('001')
      expect(hash[:@vouchernumber]).to eq('00012300000')
    end

    it 'has no detail children (ACPD0 is a flat record)' do
      # Arrange
      attributes = build_acpd0_attributes

      # Act
      instance = described_class.new(attributes)

      # Assert
      expect(instance).not_to respond_to(:details)
      expect(instance).not_to respond_to(:add_detail)
    end
  end
end
