# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class DocumentQueryBase < QueryBase
        def initialize(document_references)
          @document_references = document_references
        end

        protected

        def input_hash
          input_base_hash
        end
      end
    end
  end
end
