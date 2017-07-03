# frozen_string_literal: true
module Agris
  module Api
    autoload :AccountsReceivables, 'agris/api/accounts_receivables'
    autoload :AccountsPayables, 'agris/api/accounts_payables'
    autoload :DocumentQueryResponse,
             'agris/api/document_query_response'
    autoload :Grain, 'agris/api/grain'
    autoload :Inventory, 'agris/api/inventory'
    autoload :Messages, 'agris/api/messages'
    autoload :NewOrder, 'agris/api/new_order'
    autoload :NewOrderRemark, 'agris/api/new_order_remark'
    autoload :NewVoucher, 'agris/api/new_voucher'
    autoload :Order, 'agris/api/order'
    autoload :OrderLine, 'agris/api/order_line'
    autoload :PostResult, 'agris/api/post_result'
    autoload :Remark, 'agris/api/remark'
    autoload :Support, 'agris/api/support'
    autoload :TranCode, 'agris/api/tran_code'
  end
end
