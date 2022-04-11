# frozen_string_literal: true
module Agris
  module Api
    module Grain
      class GradeFactors
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          discount_code_1
          discount_code_2
          discount_code_3
          discount_code_4
          discount_code_5
          discount_code_6
          discount_code_7
          discount_code_8
          discount_code_9
          discount_code_10
          discount_code_11
          discount_code_12
          discount_code_13
          discount_code_14
          discount_code_15
          discount_code_16
          discount_code_17
          discount_code_18
          discount_code_19
          discount_code_20
          discount_code_21
          discount_code_22
          discount_code_23
          discount_code_24
          discount_code_25
          discount_code_26
          discount_code_27
          discount_code_28
          discount_code_29
          discount_code_30
          discount_code_31
          discount_code_32
          discount_code_33
          grade_factor_1
          grade_factor_2
          grade_factor_3
          grade_factor_4
          grade_factor_5
          grade_factor_6
          grade_factor_7
          grade_factor_8
          grade_factor_9
          grade_factor_10
          grade_factor_11
          grade_factor_12
          grade_factor_13
          grade_factor_14
          grade_factor_15
          grade_factor_16
          grade_factor_17
          grade_factor_18
          grade_factor_19
          grade_factor_20
          grade_factor_21
          grade_factor_22
          grade_factor_23
          grade_factor_24
          grade_factor_25
          grade_factor_26
          grade_factor_27
          grade_factor_28
          grade_factor_29
          grade_factor_30
          grade_factor_31
          grade_factor_32
          grade_factor_33
          reserved_1
          reserved_2
          reserved_3
          reserved_4
          reserved_5
          reserved_6
          reserved_7
          reserved_8
          reserved_9
          reserved_10
          reserved_11
          reserved_12
          reserved_13
          reserved_14
          reserved_15
          reserved_16
          reserved_17
          reserved_18
          reserved_19
          reserved_20
          reserved_21
          reserved_22
          reserved_23
          reserved_24
          reserved_25
          reserved_26
          reserved_27
          reserved_28
          reserved_29
          reserved_30
          reserved_31
          reserved_32
          reserved_33
        ).freeze

        attr_reader :record_type
        attr_accessor(*ATTRIBUTE_NAMES)

        def initialize(hash = {})
          super

          @record_type = 'GRNT0G'
        end
      end
    end
  end
end
