# frozen_string_literal: true
module Agris
  module Api
    PostResult = Struct.new(:response) do
      def document_number
        results["result"]["document"]
      end

      def reject_reasons
        results["result"]["rejects"]["reject"]
          .compact
          .map { |rejection| rejection["reason"] }
      end

      def results
        response.output_hash["results"]
      end

      def status
        results.fetch("result", "status" => "No Result").fetch("status")
      end
    end
  end
end
