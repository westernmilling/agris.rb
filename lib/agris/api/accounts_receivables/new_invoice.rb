# frozen_string_literal: true
module Agris
  module Api
    module AccountsReceivables
      class NewInvoice
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          recordtype
          invoicelocation
          invoiceno
          billtoid
          doctype
          invoicedate
          originaldate
          duedate
          shipdate
          discountdate
          invoiceamount
          taxamount1
          discountamount
          invoicetype
          nameidtype
          statecountycode
          trancode1
          trancode2
          trancode3
          trancode4
          trancode5
          refordernumber
          usrorderfield1
          usrorderfield2
          usrinvoicefield1
          usrinvoicefield2
          invoicedesc
          termscode
          shiptoid
          shipperid
          agentid
          firstinvsettleno
          taxamount2
          taxamount3
          taxamount4
          autoapplybookings
          bookinglocation
          usebookprice
          sendtojdfmultiuse
          cardnumber
          validatecardnumber
          currencycode
          exchangeratedate
          exchangerate
          pickupdelivery
        ).freeze

        attr_reader :record_type
        attr_accessor(*ATTRIBUTE_NAMES)

        def initialize(hash = {})
          super

          @record_type = 'ACRI0'
        end

        def records
          [self]
        end
      end
    end
  end
end
