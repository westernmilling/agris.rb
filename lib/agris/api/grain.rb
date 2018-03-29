# frozen_string_literal: true
module Agris
  module Api
    module Grain
      autoload :Contract, 'agris/api/grain/contract'
      autoload :PurchaseContracts, 'agris/api/grain/purchase_contracts'
      autoload :NewTicket, 'agris/api/grain/new_ticket'
      autoload :NewTicketApplication, 'agris/api/grain/new_ticket_application'
      autoload :NewTicketRemark, 'agris/api/grain/new_ticket_remark'
      autoload :SpecificPurchaseContractExtract,
               'agris/api/grain/specific_purchase_contract_extract'
      autoload :Tickets,
               'agris/api/grain/tickets'
    end
  end
end
