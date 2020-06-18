# frozen_string_literal: true
module Agris
  module Api
    module AccountsReceivables
      autoload :Invoice, 'agris/api/accounts_receivables/invoice'
      autoload :Invoices, 'agris/api/accounts_receivables/invoices'
      autoload :SpecificInvoiceExtract,
               'agris/api/accounts_receivables/specific_invoice_extract'
      autoload :NewInvoice, 'agris/api/accounts_receivables/new_invoice'
    end
  end
end
