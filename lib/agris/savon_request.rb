# frozen_string_literal: true
require "agris/user_agent"
require "savon"

module Agris
  class SavonRequest
    def initialize(base_url, credentials, logger, proxy_url = nil)
      @base_url = base_url
      @credentials = credentials
      @logger = logger
      @proxy_url = proxy_url
    end

    def process_message(context, message_number, input)
      response = client.call(
        :process_message,
        message: {
          AgContext_str_p: context,
          AgMessage_int_p: message_number,
          AgInput_obj_p: input
        }
      )
      message_response = parse_response(response)

      fail response_error(message_response.error_info) \
        if message_response.error?

      message_response
    end

    protected

    def parse_response(response)
      ProcessMessageResponse.new(
        response.body[:process_message_result],
        response.body[:process_message_response][:ag_output_obj_p],
        response.body[:process_message_response][:ag_error_str_p]
      )
    end

    def client
      options = {
        wsdl: wsdl,
        convert_request_keys_to: :none,
        raise_errors: false,
        logger: @logger,
        log: true,
        log_level: :debug
      }
      options = options.merge(proxy: @proxy_url) unless @proxy_url.to_s == ""
      options = @credentials.apply(options)

      Savon.client(options)
    end

    def response_error(error_info)
      Object.const_get(
        format(
          "Agris::%<error_name>sError",
          error_name: error_info.type.to_s.split("_").map(&:capitalize).join
        )
      ).new(error_info.payload)
    end

    def wsdl
      format(
        "%<base_url>s/%<path>s",
        base_url: @base_url,
        path: "agris/AGRIS.Env.MessageRouter/AGRIS.Env.MessageRouter.asmx?WSDL"
      )
    end
  end
end
