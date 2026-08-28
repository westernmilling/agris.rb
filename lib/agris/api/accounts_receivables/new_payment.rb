# frozen_string_literal: true

module Agris
  module Api
    module AccountsReceivables
      class NewPayment
        include XmlModel

        RECEIVE_ON_ACCOUNT = '0'
        APPLY_TO_INVOICE = 'E'

        ATTRIBUTE_NAMES = %w(
          applied_date
          apply_receive_on_acct
          bank_code
          cash_source
          check_number
          discount_amount
          invoice_line_pricing_no
          invoice_location
          name_id
          payment_amount
          payment_date
          receipt_location
          receipt_number
          record_type
        ).freeze

        attr_reader(*ATTRIBUTE_NAMES)

        # Agris allocates the receipt number, so it is left for the response.
        # An applied date or invoice on an unapplied receipt is rejected.
        def self.receive(attributes = {})
          new(
            attributes.merge(
              apply_receive_on_acct: RECEIVE_ON_ACCOUNT,
              applied_date: '',
              invoice_line_pricing_no: ''
            )
          )
        end

        # Draws down the unapplied balance of a receipt Agris already
        # allocated; it cannot create one.
        def self.apply(attributes = {})
          new(attributes.merge(apply_receive_on_acct: APPLY_TO_INVOICE))
        end

        def initialize(attributes = {})
          super

          @record_type = 'ACRR0'
          @remarks = []
        end

        def add_remark(remark)
          @remarks << remark

          self
        end

        def remarks
          @remarks || []
        end

        def records
          [self] + remarks
        end

        def for_allocation(allocation)
          allocated = self.class.new(hash.merge(allocation_hash(allocation)))

          remarks.each do |remark|
            allocated.add_remark(remark.for_allocation(allocation))
          end

          allocated
        end

        def xml_ignore_attributes
          [:remarks]
        end

        protected

        def allocation_hash(allocation)
          {
            bank_code: allocation.bank_code,
            receipt_location: allocation.receipt_location,
            receipt_number: allocation.receipt_number
          }
        end
      end
    end
  end
end
