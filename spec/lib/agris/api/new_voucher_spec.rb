# frozen_string_literal: true
require 'spec_helper'

describe Agris::Api::NewVoucher do
  def build_general_ledger_detail
    described_class::GeneralLedgerDetail.new(
      distribution_amount: '230.85',
      gl_account_main_code: '48670',
      gl_account_detail_code: 'WN'
    )
  end

  def build_freight_ticket_reference_detail
    described_class::FreightTicketReferenceDetail.new(
      in_out_code: 'I',
      ticket_location: '051',
      ticket_number: '0028786',
      freight_amount: '230.85'
    )
  end

  describe '#add_detail' do
    context 'with a general ledger detail and a freight ticket reference' do
      it 'exposes both details in insertion order' do
        # Arrange
        voucher = described_class.new(voucher_amount: '230.85')
        gl_detail = build_general_ledger_detail
        ticket_detail = build_freight_ticket_reference_detail

        # Act
        voucher.add_detail(gl_detail)
        voucher.add_detail(ticket_detail)

        # Assert
        expect(voucher.details).to eq([gl_detail, ticket_detail])
      end

      it 'serializes each detail to its own record type' do
        # Arrange
        voucher = described_class.new(voucher_amount: '230.85')
        voucher.add_detail(build_general_ledger_detail)
        voucher.add_detail(build_freight_ticket_reference_detail)

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
        voucher = described_class.new(voucher_amount: '230.85')
        voucher.add_detail(build_freight_ticket_reference_detail)

        # Act
        hash = voucher.to_xml_hash

        # Assert
        expect(hash).to eq(:@voucheramount => '230.85', :@recordtype => 'ACPV0')
      end
    end
  end
end
