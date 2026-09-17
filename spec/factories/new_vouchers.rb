# frozen_string_literal: true

# XmlModel classes take a single attribute hash and expose no setters, so
# every factory here builds through the constructor. Default values are the
# freight voucher posted to staging AGRIS on 2026-09-14: inbound ticket
# 051 0028786, freight 230.85, carrier 1002424-00.
FactoryBot.define do
  factory :new_voucher, class: 'Agris::Api::NewVoucher' do
    doc_type { '2' }
    remit_to_id { '1002424-00' }
    shipper_id { '1002424-00' }
    voucher_amount { '230.85' }
    voucher_type { 'FV' }

    initialize_with { new(attributes) }

    trait :freight do
      after(:build) do |voucher|
        voucher.add_detail(build(:general_ledger_detail))
        voucher.add_detail(build(:freight_ticket_reference_detail))
      end
    end
  end

  factory :general_ledger_detail,
          class: 'Agris::Api::NewVoucher::GeneralLedgerDetail' do
    distribution_amount { '230.85' }
    gl_account_main_code { '48670' }
    gl_account_detail_code { 'WN' }

    initialize_with { new(attributes) }
  end

  factory :freight_ticket_reference_detail,
          class: 'Agris::Api::NewVoucher::FreightTicketReferenceDetail' do
    in_out_code { 'I' }
    ticket_location { '051' }
    ticket_number { '0028786' }
    freight_amount { '230.85' }

    initialize_with { new(attributes) }
  end
end
