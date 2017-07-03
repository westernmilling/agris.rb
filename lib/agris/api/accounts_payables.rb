# frozen_string_literal: true

module Agris
  module Api
    module AccountsPayables
      module Vouchers
        def create_voucher(voucher)
          response = @request.process_message(
            Gyoku.xml(xml: context_hash),
            82_320,
            create_post_payload_xml(convert_voucher_to_details(voucher))
          )

          PostResult.new(response)
        end

        protected

        # NB: We should probably refactor this into a class and write tests
        #     to verify conversion of a sales model to an expected payload.
        def convert_voucher_to_details(voucher)
          details = []
          details << voucher.to_xml_hash
          details << voucher.details.map(&:to_xml_hash)
          details
        end
      end
    end
  end
end
