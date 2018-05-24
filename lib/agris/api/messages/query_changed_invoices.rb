# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class QueryChangedInvoices < ChangedQueryBase
        def message_number
          80_500
        end

        protected

        def xml_hash
          xml_base_hash
            .merge(
              componentdetail: true,
              discountdetail: true,
              gldistributiondetail: true,
              lineitemdetail: true,
              lineremarkdetail: true,
              remarkdetail: true,
              specificationdetail: true,
              splitdetail: true,
              taxdetail: true,
              taxratedetail: true,
              trancodedetail: true
            )
        end
      end
    end
  end
end
