# frozen_string_literal: true

# XmlModel classes take a single attribute hash and expose no setters, so the
# factory builds through the constructor. Defaults are the freight voucher
# posted to staging AGRIS on 2026-09-14 (carrier 1002424-00, 230.85).
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
end
