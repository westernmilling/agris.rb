# frozen_string_literal: true
module Agris
  module Api
    module Grain
      class Commodity
        include XmlModel

        def self.pluralized_name
          "commodities"
        end

        ATTRIBUTE_NAMES = %w(
          unique_id
          integration_guid
          location
          location_description
          code
          code_description
          dpr_by_variety_class
          buy_sell_uom_code
          buy_sell_uom
          inv_buy_sell_uom_code
          inv_buy_sell_uom_code_desc
          position_uom
          ledger_uom
          buy_sell_weight_factor
          position_weight_factor
          ledger_weight_factor
          status
          status_description
          hedgeable
          valid_future_month
          nearby_future_month
          default_future_month
          default_board_name
          inbound_freight_account
          inbound_freight_account_desc
          outbound_freight_account
          outbound_freight_account_desc
          ar_invoice_type
          ar_invoice_type_desc
          position_report_field_1
          position_report_field_2
          ap_voucher_type
          ap_voucher_type_desc
          taxable_1
          taxable_2
          taxable_3
          taxable_4
          inbound_adjust_prcnt
          outbound_adjust_prcnt
          minimum_price
          maximum_price
          cash_price
          cash_basis
          freight_tax_percent
          hedge_percent
          uom_product_group
          uom_product_group_description
          delete
          lastchangedatetime
          last_change_user_id
          last_change_user_name
        ).freeze

        attr_reader(*ATTRIBUTE_NAMES)
      end
    end
  end
end
