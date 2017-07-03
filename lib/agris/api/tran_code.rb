# frozen_string_literal: true
module Agris
  module Api
    class TranCode
      include XmlModel

      ATTRIBUTE_NAMES = %w(
        num
        label
        code
        description
      ).freeze

      attr_reader(*ATTRIBUTE_NAMES)
    end
  end
end
