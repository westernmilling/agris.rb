# frozen_string_literal: true
module Agris
  module Api
    module Inventory
      module DeliveryTickets
        def delivery_ticket(ticket_location, ticket_number)
          extract = SpecificDeliveryTicketExtract.new(
            ticket_location, ticket_number
          )

          delivery_tickets([extract])
        end

        def delivery_tickets(extracts)
          extract_documents(
            Messages::QueryDeliveryTicketDocuments.new(extracts),
            DeliveryTicket
          )
        end

        def delivery_tickets_changed_since(datetime)
          extract_documents(
            Messages::QueryChangedDeliveryTickets.new(datetime),
            DeliveryTicket
          )
        end
      end
    end
  end
end
