# frozen_string_literal: true
module Agris
  module Api
    module Inventory
      class SpecificDeliveryTicketExtract
        include ::Agris::XmlModel

        attr_accessor :ticket_location, :ticket_number

        def initialize(ticket_location, ticket_number)
          @ticket_location = ticket_location
          @ticket_number = ticket_number
        end
      end
    end
  end
end
