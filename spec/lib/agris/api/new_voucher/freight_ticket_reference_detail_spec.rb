# frozen_string_literal: true
require 'spec_helper'

# Spec: docs/specs/accounts-payables/freight-ticket-reference.md
describe Agris::Api::NewVoucher::FreightTicketReferenceDetail do
  # Values from the staging spike recorded in the spec (Consumer Guidance):
  # inbound ticket 051 0028786, freight 230.85
  def build_acpv3_attributes
    {
      in_out_code: 'I',
      ticket_location: '051',
      ticket_number: '0028786',
      freight_amount: '230.85'
    }
  end

  describe '#initialize' do
    # AT1 (R2)
    it 'defaults record_type to ACPV3' do
      # Arrange
      # (no setup - exercising the default path)

      # Act
      instance = described_class.new

      # Assert
      expect(instance.record_type).to eq('ACPV3')
    end

    # AT1 (E1)
    it 'overrides any record_type passed in the hash' do
      # Arrange
      attributes = { record_type: 'OTHER' }

      # Act
      instance = described_class.new(attributes)

      # Assert
      expect(instance.record_type).to eq('ACPV3')
    end

    # AT3 (R4)
    it 'exposes a reader for each ticket attribute' do
      # Arrange
      attributes = build_acpv3_attributes

      # Act
      instance = described_class.new(attributes)

      # Assert
      expect(instance).to have_attributes(
        in_out_code: 'I',
        ticket_location: '051',
        ticket_number: '0028786',
        freight_amount: '230.85'
      )
    end

    # AT5 (E2)
    it 'returns nil from readers for omitted attributes' do
      # Arrange
      attributes = { ticket_number: '0028786' }

      # Act
      instance = described_class.new(attributes)

      # Assert
      expect(instance).to have_attributes(
        in_out_code: nil,
        ticket_location: nil,
        freight_amount: nil,
        ticket_number: '0028786'
      )
    end
  end

  describe '::ATTRIBUTE_NAMES' do
    # AT2 (R1)
    it 'lists the four ticket attributes plus record_type' do
      # Arrange
      # (constant under test)

      # Act
      names = described_class::ATTRIBUTE_NAMES

      # Assert
      expect(names).to contain_exactly(
        'in_out_code',
        'ticket_location',
        'ticket_number',
        'freight_amount',
        'record_type'
      )
    end
  end

  describe '#to_xml_hash' do
    # AT1 (R2)
    it 'serializes record_type as :@recordtype with the ACPV3 default' do
      # Arrange
      # (no setup - exercising the default path)

      # Act
      hash = described_class.new.to_xml_hash

      # Assert
      expect(hash[:@recordtype]).to eq('ACPV3')
    end

    # AT2 (R3)
    it 'serializes the ACPV3 record with underscore-stripped @-keys' do
      # Arrange
      attributes = build_acpv3_attributes

      # Act
      hash = described_class.new(attributes).to_xml_hash

      # Assert
      expect(hash).to eq(
        :@inoutcode => 'I',
        :@ticketlocation => '051',
        :@ticketnumber => '0028786',
        :@freightamount => '230.85',
        :@recordtype => 'ACPV3'
      )
    end

    # AT5 (E2)
    it 'omits keys for attributes that were not supplied' do
      # Arrange
      attributes = { ticket_number: '0028786' }

      # Act
      hash = described_class.new(attributes).to_xml_hash

      # Assert
      expect(hash.keys).to contain_exactly(:@ticketnumber, :@recordtype)
    end
  end
end
