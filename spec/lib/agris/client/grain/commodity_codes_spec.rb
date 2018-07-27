# frozen_string_literal: true
require "spec_helper"
require "savon/mock/spec_helper"
require_relative "../shared_contexts"

describe Agris::Client, :agris_api_mock do
  include Savon::SpecHelper

  describe "#commodity_code" do
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

    context "when a commodity is found" do
      let(:fixture_file) { "grain/commodity_code_one_response.xml" }
      let(:location) { "ABC" }
      let(:code) { "WD" }

      it "returns the commodity_code" do
        result = client.commodity_code(location, code)

        expect(result.documents.length).to eq(1)
        expect(result.documents[0].code).to eq(code)
      end
    end

    context "when a commodity list is requested" do
      let(:fixture_file) { "grain/commodity_code_two_response.xml" }
      it "returns the commodity_codes" do
        result = client.commodity_code
        expect(result.documents.length).to eq(2)
      end
    end

    context "when a commodity is not found" do
      let(:fixture_file) { "grain/commodity_code_not_found_response.xml" }
      let(:location) { "ABC" }
      let(:code) { "1" }

      it "returns no commodity" do
        result = client.commodity_code(location, code)

        expect(result.documents.length).to eq(0)
      end
    end
  end
end
