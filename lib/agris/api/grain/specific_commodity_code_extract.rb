# frozen_string_literal: true
module Agris
  module Api
    module Grain
      class SpecificCommodityCodeExtract
        include ::Agris::XmlModel

        attr_accessor :location, :code

        def initialize(location, code)
          @location = location
          @code = code
        end
      end
    end
  end
end
