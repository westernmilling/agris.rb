# frozen_string_literal: true

module Agris
  module Api
    module AccountsReceivables
      # The posted receipt comes back in `document` as a fixed-width triple:
      # receipt location (3), receipt number (6), bank code (2).
      class PaymentPostResult < PostResult
        def receipt_location
          document_field(0, 3)
        end

        def receipt_number
          document_field(3, 6)
        end

        def bank_code
          document_field(9, 2)
        end

        # A rejected post still returns the location and bank code, so only the
        # receipt number tells you whether Agris allocated a receipt.
        def allocated?
          !receipt_number.empty?
        end

        protected

        def document_field(offset, length)
          document_number.to_s[offset, length].to_s.strip
        end
      end
    end
  end
end
