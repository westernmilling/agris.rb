# frozen_string_literal: true
module Agris
  module Api
    module Grain
      autoload :NewTicket, 'agris/api/grain/new_ticket'
      autoload :NewTicketApplication, 'agris/api/grain/new_ticket_application'
      autoload :NewTicketRemark, 'agris/api/grain/new_ticket_remark'
      autoload :Tickets,
               'agris/api/grain/tickets'
    end
  end
end
