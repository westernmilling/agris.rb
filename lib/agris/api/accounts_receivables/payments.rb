# frozen_string_literal: true

module Agris
  module Api
    module AccountsReceivables
      module Payments
        def create_payment(payment)
          post_payment(payment)
        end

        # Agris will not accept a receipt and its applications in one message,
        # so each application posts against the receipt Agris allocated.
        def apply_payment(payment, allocation)
          post_payment(payment.for_allocation(allocation))
        end

        protected

        def post_payment(payment)
          message = Messages::Import.new(payment)

          response = @request.process_message(
            Gyoku.xml(xml: context_hash),
            message.message_number,
            message.to_xml
          )

          PaymentPostResult.new(response)
        end
      end
    end
  end
end
