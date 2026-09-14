# frozen_string_literal: true
module Agris
  module Api
    module AccountsReceivables
      autoload :Invoice, 'agris/api/accounts_receivables/invoice'
      autoload :Invoices, 'agris/api/accounts_receivables/invoices'
      autoload :NewPayment, 'agris/api/accounts_receivables/new_payment'
      autoload :NewPaymentRemark,
               'agris/api/accounts_receivables/new_payment_remark'
      autoload :PaymentPostResult,
               'agris/api/accounts_receivables/payment_post_result'
      autoload :Payments, 'agris/api/accounts_receivables/payments'
      autoload :SpecificInvoiceExtract,
               'agris/api/accounts_receivables/specific_invoice_extract'
    end
  end
end
