# frozen_string_literal: true
require 'spec_helper'

describe Agris::Api::NewVoucher do
  describe '#add_detail' do
    context 'with a general ledger detail and a freight ticket reference' do
      it 'exposes both details in insertion order' do
        # Arrange
        voucher = build(:new_voucher)
        gl_detail = build(:general_ledger_detail)
        ticket_detail = build(:freight_ticket_reference_detail)

        # Act
        voucher.add_detail(gl_detail)
        voucher.add_detail(ticket_detail)

        # Assert
        expect(voucher.details).to eq([gl_detail, ticket_detail])
      end

      it 'serializes each detail to its own record type' do
        # Arrange
        voucher = build(:new_voucher, :freight)

        # Act
        hashes = voucher.details.map(&:to_xml_hash)

        # Assert
        expect(hashes.map { |hash| hash[:@recordtype] })
          .to eq(%w(ACPV2 ACPV3))
        expect(hashes.last).to include(
          :@ticketnumber => '0028786',
          :@freightamount => '230.85'
        )
      end

      it 'keeps details out of the header xml hash' do
        # Arrange
        voucher = build(:new_voucher, :freight)

        # Act
        hash = voucher.to_xml_hash

        # Assert
        expect(hash.keys).not_to include(:@details)
        expect(hash).to include(:@recordtype => 'ACPV0', :@voucheramount => '230.85')
      end
    end
  end
end
