# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class MessageBase
        def message_number
          fail 'You must override the message number'
        end

        def to_xml
          Gyoku.xml(message_hash)
        end

        protected

        def input_base_hash
          {}
        end

        def input_hash
          fail 'You must override the input_hash'
        end

        def message_hash
          {
            xml: xml_hash
          }
        end

        def xml_base_hash
          {
            input: input_hash
          }
        end

        def xml_hash
          fail 'You must override the input_hash'
        end
      end
    end
  end
end
