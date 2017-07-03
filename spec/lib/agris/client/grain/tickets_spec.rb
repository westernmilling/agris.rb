# frozen_string_literal: true
require 'spec_helper'
require 'savon/mock/spec_helper'
require_relative '../shared_contexts'

describe Agris::Client, :agris_api_mock do
  include Savon::SpecHelper

  describe '#create_ticket' do
    include_context 'test agris client'

    before do
      savon
        .expects(:process_message)
        .with(message: :any)
        .returns(response_body)
    end

    let(:new_ticket) { Agris::Api::Grain::NewTicket.new }
    let(:response_body) do
      File.read(File.join(%W(./ spec fixtures agris #{fixture_file})))
    end

    context 'when the post is rejected' do
      let(:fixture_file) { 'grain/import_ticket_rejection.xml' }

      it 'should return a result with status of Rejected' do
        result = client.create_ticket(new_ticket)

        expect(result.status).to eq 'Rejected'
      end
    end

    context 'when the post is processed' do
      let(:fixture_file) { 'grain/import_ticket_processed.xml' }

      it 'should return a result with status of Processed' do
        result = client.create_ticket(new_ticket)

        expect(result.status).to eq 'Processed'
      end
    end
  end
end
