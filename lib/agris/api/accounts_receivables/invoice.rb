# frozen_string_literal: true
module Agris
  module Api
    module AccountsReceivables
      class Invoice
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          invoice_location
          invoice_location_description
          invoice_no
          invoice_date
          ship_date
          pickup_delivery
          due_date
          discount_date
          original_date
          last_pay_date
          trans_status
          tran_status_desc
          aging_period
          aging_period_description
          doc_type
          doc_type_desc
          invoice_desc
          ref_order_no
          xref_doc_loc
          xref_doc_loc_description
          xref_doc
          days_to_pay
          terms_code
          terms_desc
          first_inv_settle_no
          name_id_type
          name_id_type_desc
          invoice_type
          invoice_type_desc
          state_county_code
          state_county_desc
          usr_order_field_1
          usr_order_field_2
          usr_invoice_field1
          usr_invoice_field2
          bill_to_id
          bill_to_description
          ship_to_id
          ship_to_description
          shipper_id
          shipper_description
          agent_id
          agent_description
          invoice_amount
          discount_amount
          applied_amount
          due_amount
          net_amount
          discount_remaining
          discount_applied
          sales_tax
          field_history_updated
          use_standard_discount_ratio
          delete
          lastchange_datetime
          lastchange_user_id
          lastchange_user_name
          currency_code
          currency_description
          exchange_rate
          exchange_rate_date
          integration_guid
          unique_id
        ).freeze

        attr_reader(*(%w(line_items) + ATTRIBUTE_NAMES))
        attr_accessor(*(%w(line_items) + ATTRIBUTE_NAMES))

        def records
          [self]
        end

        def self.from_xml_hash(hash)
          super.tap do |document|
            if hash['lineitems']
              document.line_items.concat(
                [hash['lineitems']['lineitem']]
                  .flatten
                  .map do |lineitem|
                    LineItem.from_xml_hash(lineitem)
                  end
              )
            end
          end
        end

        def initialize(hash = {})
          super

          @record_type = 'ACRI0'
          @line_items = []
        end

        class LineItem
          include XmlModel

          ATTRIBUTE_NAMES = %w(
            line_item_no
            pricing_no
            item_loc
            item_loc_desc
            item_no
            item_desc
            sub_item_1
            sub_item_1_desc
            sub_item_2
            category
            category_desc
            category_type
            category_type_desc
            qty
            qty_uom
            qty_uom_desc
            unit_price
            total_price
            pre_promo_price
            discount_rate
            original_qty
            split_percent
            unit_cost
            total_cost
            price_uom
            price_uom_desc
            order_loc
            order_loc_desc
            order_no
            other_ref
            exec_id_no
            exec_id_description
            act_loc
            act_loc_desc
            sales_tax_amt
            scale_ticket_num
            weight_uom
            weight_uom_desc
            gross_wt
            tare_wt
            net_wt
            del_ticket_loc
            del_ticket_loc_desc
            del_ticket_no
            contract_loc
            contract_loc_desc
            contract_no
            item_type
            item_type_description
            in_blend
            source_type
            blend_no
            formula_no
            source_id
            target_p_est
            change_type
            change_type_description
            cost_adjustment_status
            cost_adjustment_description
          ).freeze

          attr_reader(*ATTRIBUTE_NAMES)
          attr_accessor(*ATTRIBUTE_NAMES)
        end
      end
    end
  end
end
