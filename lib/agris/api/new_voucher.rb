# frozen_string_literal: true

module Agris
  module Api
    class NewVoucher
      include XmlModel

      attr_reader :details

      ATTRIBUTE_NAMES = %w(
        agent_id
        currency_code
        discount_amount
        discount_date
        doc_type
        due_date
        exchange_rate
        exchange_rate_date
        first_voucher_no
        name_id_type
        original_date
        record_type
        remark_value
        remit_to_id
        ship_from_id
        shipper_id
        state_county
        terms_code
        their_invoice_no
        their_order_no
        trancode_1
        trancode_2
        trancode_3
        trancode_4
        trancode_5
        trans_status
        usr_order_field_1
        usr_order_field_2
        voucher_amount
        voucher_date
        voucher_description
        voucher_location
        voucher_number
        voucher_type
      ).freeze

      attr_reader(*ATTRIBUTE_NAMES)

      def initialize(hash = {})
        super

        @details = []
        @record_type = "ACPV0"
      end

      def add_detail(voucher)
        @details << voucher
      end

      def xml_ignore_attributes
        [:details]
      end

      class GeneralLedgerDetail
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          distribution_amount
          execution_id
          gl_account_main_code
          gl_account_detail_code
          gl_account_profit_center
          gl_loc_code
          record_type
        ).freeze

        def initialize(hash = {})
          super

          @record_type = "ACPV2"
        end
      end

      class InventoryItemDetail
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          cost_uom
          detail_type
          direct_cost
          exec_id_number
          item_loc
          item_no
          other_ref
          order_location
          order_number
          quantity
          quantity_uom
          record_type
          unit_cost
        ).freeze

        def initialize(orders, hash = {})
          super(hash)

          @detail_type = "I"
          @orders = orders
          @record_type = "ACPV1"
        end
      end
    end
  end
end
