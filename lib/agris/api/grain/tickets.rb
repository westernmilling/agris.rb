# frozen_string_literal: true
module Agris
  module Api
    module Grain
      module Tickets
        # Create a new Grain ticket in Agris.
        #
        # In future I don't think we'll need a method per type of thing we want
        # to create in Agris, but rather have a single import method that we
        # just pass in the New*** model we want to create.
        def create_ticket(ticket)
          import(ticket)
        end
      end
    end
  end
end
