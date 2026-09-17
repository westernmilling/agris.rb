# frozen_string_literal: true
require 'spec_helper'

describe Agris::Api::NewVoucher::FreightTicketReferenceDetail do
  describe '::ATTRIBUTE_NAMES' do
    it 'lists the four ticket attributes plus record_type' do
      expect(described_class::ATTRIBUTE_NAMES).to contain_exactly(
        'in_out_code',
        'ticket_location',
        'ticket_number',
        'freight_amount',
        'record_type'
      )
    end
  end

  describe '#initialize' do
    context 'without any attributes' do
      it 'defaults record_type to ACPV3' do
        # Act
        instance = described_class.new

        # Assert
        expect(instance.record_type).to eq('ACPV3')
      end
    end

    context 'when record_type is passed in the hash' do
      it 'overrides it with ACPV3' do
        # Act
        instance = build(:freight_ticket_reference_detail, record_type: 'OTHER')

        # Assert
        expect(instance.record_type).to eq('ACPV3')
      end
    end

    context 'with all four ticket attributes' do
      it 'exposes a reader for each ticket attribute' do
        # Act
        instance = build(:freight_ticket_reference_detail)

        # Assert
        expect(instance).to have_attributes(
          in_out_code: 'I',
          ticket_location: '051',
          ticket_number: '0028786',
          freight_amount: '230.85'
        )
      end
    end

    context 'with only ticket_number' do
      it 'returns nil from the readers for the omitted attributes' do
        # Act
        instance = described_class.new(ticket_number: '0028786')

        # Assert
        expect(instance).to have_attributes(
          in_out_code: nil,
          ticket_location: nil,
          freight_amount: nil,
          ticket_number: '0028786'
        )
      end
    end
  end

  describe '#to_xml_hash' do
    context 'without any attributes' do
      it 'serializes record_type as :@recordtype with the ACPV3 default' do
        # Act
        hash = described_class.new.to_xml_hash

        # Assert
        expect(hash).to eq(:@recordtype => 'ACPV3')
      end
    end

    context 'when record_type is passed in the hash' do
      it 'serializes ACPV3 regardless' do
        # Arrange
        instance = described_class.new(record_type: 'OTHER', ticket_number: '0028786')

        # Act
        hash = instance.to_xml_hash

        # Assert
        expect(hash).to eq(:@recordtype => 'ACPV3', :@ticketnumber => '0028786')
      end
    end

    context 'with all four ticket attributes' do
      it 'serializes the ACPV3 record with underscore-stripped @-keys' do
        # Arrange
        instance = build(:freight_ticket_reference_detail)

        # Act
        hash = instance.to_xml_hash

        # Assert
        expect(hash).to eq(
          :@inoutcode => 'I',
          :@ticketlocation => '051',
          :@ticketnumber => '0028786',
          :@freightamount => '230.85',
          :@recordtype => 'ACPV3'
        )
      end
    end

    context 'with only ticket_number' do
      it 'omits keys for the attributes that were not supplied' do
        # Arrange
        instance = described_class.new(ticket_number: '0028786')

        # Act
        hash = instance.to_xml_hash

        # Assert
        expect(hash.keys).to contain_exactly(:@ticketnumber, :@recordtype)
      end
    end
  end
end
