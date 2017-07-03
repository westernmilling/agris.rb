# frozen_string_literal: true
module Agris
  module Api
    module AccountsReceivables
      module Invoices
        def invoice(invoice_location, invoice_number)
          extract = Agris::Api::AccountsReceivables::SpecificInvoiceExtract
                    .new(invoice_location, invoice_number)

          invoices([extract])
        end

        def invoices(extracts)
          extract_documents(
            Messages::QueryInvoiceDocuments.new(extracts),
            Agris::Api::AccountsReceivables::Invoice
          )
        end

        def invoices_changed_since(datetime, detail = false)
          extract_documents(
            Messages::QueryChangedInvoices.new(datetime, detail),
            Agris::Api::AccountsReceivables::Invoice
          )
        end
      end
    end
  end
end
