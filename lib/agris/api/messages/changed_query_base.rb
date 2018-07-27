# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class ChangedQueryBase < QueryBase
        def initialize(time, detail)
          @time = time
          @detail = detail
        end

        protected

        def input_hash
          input_base_hash
            .merge(
              :@details => @detail,
              locid: {
                :@datetime => @time.strftime("%Y-%m-%dT%H:%M:%S"),
                :@id => nil,
                :@loccode => nil
              }
            )
        end
      end
    end
  end
end
