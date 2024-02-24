# frozen_string_literal: true
module Agris
  class Client
    include Api::AccountsPayables::Vouchers
    include Api::AccountsReceivables::Invoices
    include Api::Grain::CommodityCodes
    include Api::Grain::GrainModule
    include Api::Grain::PurchaseContracts
    include Api::Grain::SalesContracts
    include Api::Grain::Tickets
    include Api::Inventory::DeliveryTickets
    include Api::Inventory::Orders
    include Api::Support

    ##
    # Initializes the client
    #
    def initialize(
      context = Agris.context,
      credentials = Agris.credentials,
      options = {},
      dataset:
    )
      @context = context
      @logger = options[:logger] || Agris.logger
      @log_level = options[:log_level] || Agris.log_level
      @request_type = options[:request_type] || Agris.request_type
      @proxy_url = options.fetch(:proxy_url, Agris.proxy_url)
      @dataset = dataset || Agris.context.default_dataset
      @request = @request_type.new(
        @context.base_url, credentials, @logger, @log_level, @proxy_url
      )
    end

    def log(message)
      logger.info(message)
    end

    protected

    def logger
      # We may want to replace the Logger with some kind of NullLogger?
      @logger ||= Logger.new(STDOUT)
    end
  end
end
