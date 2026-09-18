# frozen_string_literal: true

FactoryBot.define do
  factory :general_ledger_detail,
          class: 'Agris::Api::NewVoucher::GeneralLedgerDetail' do
    distribution_amount { '230.85' }
    gl_account_main_code { '48670' }
    gl_account_detail_code { 'WN' }

    initialize_with { new(attributes) }
  end
end
