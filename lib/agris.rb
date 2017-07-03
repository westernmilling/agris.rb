# frozen_string_literal: true
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'active_support/core_ext/hash/conversions'
require 'active_support/core_ext/hash/slice'
require 'savon'

module Agris
  class ApiError < StandardError; end
  class MessageError < StandardError; end
  class SystemError < StandardError; end
  class UnknownError < StandardError; end

  class << self
    attr_accessor :credentials, :context, :logger, :proxy_url, :request_type
    # ```ruby
    # Agris.configure do |config|
    #   config.credentials = Agris::Credentials::Anonymous.new
    #   config.context = Agris::Context.new(
    #     'http://localhost:3000',
    #     '001',
    #     '\\host\apps\Agris\datasets',
    #     'AgrisDB',
    #     'bob',
    #     'fred'
    #   )
    #   config.request_type = Agris::SavonRequest
    #   config.logger = Logger.new(STDOUT)
    # end
    # ```
    # elsewhere
    #
    # ```ruby
    # client = Agris::Client.new
    # ```
    def configure
      yield self
      true
    end

    def root
      File.expand_path('../../', __FILE__)
    end
  end

  autoload :Api, 'agris/api'
  autoload :Client, 'agris/client'
  autoload :Context, 'agris/context'
  autoload :Credentials, 'agris/credentials'
  autoload :HTTPartyRequest, 'agris/httparty_request'
  autoload :ProcessMessageResponse, 'agris/process_message_response'
  autoload :SavonRequest, 'agris/savon_request'
  autoload :XmlModel, 'agris/xml_model'
end
