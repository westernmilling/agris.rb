# frozen_string_literal: true

module Agris
  module Api
    module AccountsReceivables
      class NewPaymentRemark
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          bank_code
          receipt_location
          receipt_number
          record_type
          remark_number
          remark_value
        ).freeze

        attr_reader(*ATTRIBUTE_NAMES)

        def initialize(attributes = {})
          super

          @record_type = 'ACRR1'
        end

        def for_allocation(allocation)
          self.class.new(
            hash.merge(
              bank_code: allocation.bank_code,
              receipt_location: allocation.receipt_location,
              receipt_number: allocation.receipt_number
            )
          )
        end
      end
    end
  end
end
