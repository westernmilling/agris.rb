# frozen_string_literal: true
module Agris
  module Credentials
    class Anonymous
      def apply(options)
        # noop
        options
      end
    end
  end
end
