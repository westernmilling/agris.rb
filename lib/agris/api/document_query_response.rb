# frozen_string_literal: true
module Agris
  module Api
    class DocumentQueryResponse
      def initialize(output_hash, resource_type = nil)
        @output_hash = output_hash
        @documents = nil
        @resource_type = resource_type if resource_type
      end

      def last_request_date_time
        Time.parse(
          @output_hash[pluralized_resource_name] \
                      ['system'] \
                      ['lastrequestdatetime']
        )
      end

      def documents
        @documents ||= parse
      end

      def remarks
        resources.map { |r| r['remarks'] }
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

      def pluralized_resource_name
        resource_type.pluralized_name
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
        [@output_hash[pluralized_resource_name][resource_name]]
          .compact
          .flatten
      end
    end
  end
end
