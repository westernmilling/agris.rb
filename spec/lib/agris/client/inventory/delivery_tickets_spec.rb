# frozen_string_literal: true
require "spec_helper"
require "savon/mock/spec_helper"
require_relative "../shared_contexts"

describe Agris::Client, :agris_api_mock do
  include Savon::SpecHelper

  describe "#delivery_tickets_changed_since" do
    include_context "test agris client"

    before do
      savon
        .expects(:process_message)
        .with(message: :any)
        .returns(response_body)
    end

    let(:response_body) do
      File.read(File.join(%W(./ spec fixtures agris #{fixture_file})))
    end
    let(:datetime) { Time.parse("2018-01-03T14:25:00)") }

    context "when delivery_tickets are returned" do
      let(:fixture_file) do
        "inventory/delivery_tickets_two_results_no_detail.xml"
      end
      let(:ticket_number_1) { "000001" }
      let(:ticket_number_2) { "000002" }

      it "returns the delivery_tickets" do
        result = client.delivery_tickets_changed_since(datetime)

        expect(result.documents.length).to eq(2)
        expect(result.documents[0].ticket_number).to eq(ticket_number_1)
        expect(result.documents[1].ticket_number).to eq(ticket_number_2)
      end
    end

    context "when no delivery_tickets are found" do
      let(:fixture_file) { "inventory/delivery_ticket_not_found_result.xml" }

      it "returns no delivery_ticket" do
        result = client.delivery_tickets_changed_since(datetime)

        expect(result.documents.length).to eq(0)
      end
    end
  end
end
