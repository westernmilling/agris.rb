# frozen_string_literal: true

module Agris
  module Api
    module Grain
      autoload :Commodity, 'agris/api/grain/commodity'
      autoload :CommodityCodes, 'agris/api/grain/commodity_codes'
      autoload :Contract, 'agris/api/grain/contract'
      autoload :GradeFactors, 'agris/api/grain/grade_factors'
      autoload :GrainModule, 'agris/api/grain/grain_module'
      autoload :PurchaseContracts, 'agris/api/grain/purchase_contracts'
      autoload :NewContract, 'agris/api/grain/new_contract'
      autoload :NewContractSchedule, 'agris/api/grain/new_contract_schedule'
      autoload :NewTicket, 'agris/api/grain/new_ticket'
      autoload :NewTicketApplication, 'agris/api/grain/new_ticket_application'
      autoload :NewTicketRemark, 'agris/api/grain/new_ticket_remark'
      autoload :Rates, 'agris/api/grain/rates'
      autoload :SalesContracts, 'agris/api/grain/sales_contracts'
      autoload :SpecificCommodityCodeExtract, 'agris/api/grain/specific_commodity_code_extract'
      autoload :SpecificContractExtract, 'agris/api/grain/specific_contract_extract'
      autoload :Tickets, 'agris/api/grain/tickets'
    end
  end
end
