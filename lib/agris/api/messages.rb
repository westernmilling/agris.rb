# frozen_string_literal: true
module Agris
  module Api
    module Messages
      autoload :MessageBase,
               'agris/api/messages/message_base'
      autoload :Import,
               'agris/api/messages/import'
      autoload :QueryBase,
               'agris/api/messages/query_base'
      autoload :QueryChangedDeliveryTickets,
               'agris/api/messages/query_changed_delivery_tickets'
      autoload :QueryChangedInvoices,
               'agris/api/messages/query_changed_invoices'
      autoload :QueryChangedOrders,
               'agris/api/messages/query_changed_orders'
      autoload :QueryDeliveryTicketDocuments,
               'agris/api/messages/query_delivery_ticket_documents'
      autoload :QueryInvoiceDocuments,
               'agris/api/messages/query_invoice_documents'
      autoload :QueryOrderDocuments,
               'agris/api/messages/query_order_documents'
    end
  end
end
