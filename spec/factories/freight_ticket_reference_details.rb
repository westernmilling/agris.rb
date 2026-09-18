# frozen_string_literal: true

# Inbound ticket 051 0028786 from the 2026-09-14 staging spike.
FactoryBot.define do
  factory :freight_ticket_reference_detail,
          class: 'Agris::Api::NewVoucher::FreightTicketReferenceDetail' do
    in_out_code { 'I' }
    ticket_location { '051' }
    ticket_number { '0028786' }
    freight_amount { '230.85' }

    initialize_with { new(attributes) }
  end
end
