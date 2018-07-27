# frozen_string_literal: true
module Agris
  module Api
    module Inventory
      autoload :DeliveryTicket, 'agris/api/inventory/delivery_ticket'
      autoload :DeliveryTicketLineItem,
               'agris/api/inventory/delivery_ticket_line_item'
      autoload :DeliveryTickets, 'agris/api/inventory/delivery_tickets'
      autoload :Orders, 'agris/api/inventory/orders'
      autoload :SpecificDeliveryTicketExtract,
               'agris/api/inventory/specific_delivery_ticket_extract'
      autoload :SpecificOrderExtract,
               'agris/api/inventory/specific_order_extract'
    end
  end
end
