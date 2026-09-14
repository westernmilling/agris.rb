# frozen_string_literal: true
module Agris
  module Api
    PostResult = Struct.new(:response) do
      def document_number
        results['result']['document']
      end

      # A processed post reports an empty `<reject />`, so there may be no
      # rejections to read.
      def reject_reasons
        rejects = results.fetch('result', {})['rejects']

        return [] if rejects.nil?

        [rejects['reject']]
          .flatten
          .compact
          .map { |rejection| rejection['reason'] }
          .compact
      end

      def results
        response.output_hash['results']
      end

      def status
        results.fetch('result', 'status' => 'No Result').fetch('status')
      end
    end
  end
end
