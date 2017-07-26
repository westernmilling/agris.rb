# frozen_string_literal: true
module Agris
  class ProcessMessageResponse
    attr_accessor :result, :ag_output_obj_p, :ag_error_str_p

    def initialize(result, ag_output_obj_p, ag_error_str_p)
      @result = result
      @ag_output_obj_p = ag_output_obj_p
      @ag_error_str_p = ag_error_str_p
    end

    def error?
      ag_error_str_p.present?
    end

    def error_info
      @error ||= error? ? ErrorInfo.new(error_hash) : nil
    end

    def error_hash
      @error_hash ||= Hash.from_xml(ag_error_str_p)
    end

    def output_hash
      @output_hash ||= Hash.from_xml(ag_output_obj_p)
    end

    class ErrorInfo
      def initialize(hash)
        @hash = hash
      end

      def payload
        if @hash.key?('xml')
          @hash['xml']['errors']['errorinfo']
        elsif @hash['errorinfo'].is_a?(Hash)
          @hash['errorinfo']
        elsif @hash['errorinfo'].is_a?(String)
          @hash['errorinfo'].strip
        else
          @hash
        end
      end

      def type
        @type ||= if @hash.key?('xml')
                    :message
                  elsif @hash['errorinfo'].is_a?(Hash)
                    :system
                  elsif @hash['errorinfo'].is_a?(String)
                    :api
                  else
                    :unknown
                  end
      end
    end
  end
end
