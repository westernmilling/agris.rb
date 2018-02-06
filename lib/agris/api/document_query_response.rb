# frozen_string_literal: true
module Agris
  module Api
    class DocumentQueryResponse
      def initialize(output_hash, resource_type = nil)
        @output_hash = output_hash
        @objects = nil
        @resource_type = resource_type if resource_type
      end

      def last_request_date_time
        DateTime.parse(
          @output_hash["#{resource_name}s"]['system']['lastrequestdatetime']
        )
      end

      def documents
        @objects ||= parse
      end

      protected

      def parse
        resources
          .map do |order_hash|
          resource_type.from_xml_hash(order_hash)
        end
      end

      def resource_name
        @resource_name ||= resource_type
                           .name
                           .split('::')
                           .last
                           .downcase
      end

      def resource_type
        @resource_type ||= Object.const_get(
          self
            .class
            .name
            .split('::')
            .last
            .chomp('ExtractResponse')
        )
      end

      def resources
        # Wrap and flatten for single responses
        [@output_hash["#{resource_name}s"][resource_name]]
          .compact
          .flatten
      end
    end
  end
end
# rubocop:enable Rails/TimeZone
