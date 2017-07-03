# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class QueryChangedInvoices < QueryBase
        def initialize(time, detail)
          @time = time
          @detail = detail
        end

        def message_number
          80_500
        end

        protected

        def input_hash
          input_base_hash
            .merge(
              :@details => @detail,
              locid: {
                :@datetime => @time.strftime('%Y-%m-%dT%H:%M:%S'),
                :@id => nil,
                :@loccode => nil
              }
            )
        end

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
