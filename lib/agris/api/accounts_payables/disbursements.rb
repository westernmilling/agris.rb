# frozen_string_literal: true

module Agris
  module Api
    module AccountsPayables
      module Disbursements
        def create_disbursement(disbursement)
          response = @request.process_message(
            Gyoku.xml(xml: context_hash),
            82_320,
            create_post_payload_xml([disbursement.to_xml_hash])
          )

          PostResult.new(response)
        end
      end
    end
  end
end
