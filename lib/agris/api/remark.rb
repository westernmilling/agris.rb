# frozen_string_literal: true
module Agris
  module Api
    class Remark
      include XmlModel

      ATTRIBUTE_NAMES = %w(
        number
        label
        value
      ).freeze

      attr_reader(*ATTRIBUTE_NAMES)
    end
  end
end
