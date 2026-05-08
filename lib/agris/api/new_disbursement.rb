# frozen_string_literal: true

module Agris
  module Api
    class NewDisbursement
      include XmlModel

      ATTRIBUTE_NAMES = %w(
        applied_date
        apply_payment_on_account
        bank_code
        cash_source
        check_location
        check_number
        currency_code
        discount_amount
        exchange_rate
        exchange_rate_date
        misc_reference
        name_id
        payment_amount
        payment_date
        prepayment_reference
        prepayment_type
        record_type
        reserved
        voucher_location
        voucher_number
      ).freeze

      attr_reader(*ATTRIBUTE_NAMES)

      def initialize(hash = {})
        super

        @record_type = 'ACPD0'
      end
    end
  end
end
