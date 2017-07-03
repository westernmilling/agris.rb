# frozen_string_literal: true
module Agris
  module Api
    module AccountsReceivables
      class SpecificInvoiceExtract
        include ::Agris::XmlModel

        attr_accessor :invoice_location, :invoice_no

        def initialize(invoice_location, invoice_number)
          @invoice_location = invoice_location
          @invoice_no = invoice_number
        end
      end
    end
  end
end
