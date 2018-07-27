# frozen_string_literal: true
module Agris
  module Api
    module Grain
      autoload :Commodity, "agris/api/grain/commodity"
      autoload :CommodityCodes, "agris/api/grain/commodity_codes"
      autoload :Contract, "agris/api/grain/contract"
      autoload :PurchaseContracts, "agris/api/grain/purchase_contracts"
      autoload :NewTicket, "agris/api/grain/new_ticket"
      autoload :NewTicketApplication, "agris/api/grain/new_ticket_application"
      autoload :NewTicketRemark, "agris/api/grain/new_ticket_remark"
      autoload :SpecificCommodityCodeExtract,
               "agris/api/grain/specific_commodity_code_extract"
      autoload :SpecificPurchaseContractExtract,
               "agris/api/grain/specific_purchase_contract_extract"
      autoload :Tickets,
               "agris/api/grain/tickets"
    end
  end
end
