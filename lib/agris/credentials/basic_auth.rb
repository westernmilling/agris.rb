# frozen_string_literal: true
module Agris
  module Credentials
    class BasicAuth
      def initialize(username, password)
        @username = username
        @password = password
      end

      def apply(options)
        options.merge(basic_auth: [@username, @password])
      end
    end
  end
end
