# frozen_string_literal: true
require 'spec_helper'
require 'savon/mock/spec_helper'
require_relative 'client/shared_contexts'

describe Agris::Client, :agris_api_mock do
  include Savon::SpecHelper
  include_context 'test agris client'

  before do
    savon
      .expects(:process_message)
      .with(message: :any)
      .returns(response_body)
  end

  let(:agris_new_order) do
    Agris::Api::NewOrder.new
  end
  let(:response_body) do
    File.read(File.join(%W(./ spec fixtures agris #{fixture_file})))
  end

  context 'when the post is rejected' do
    let(:fixture_file) { 'create_order_rejection.xml' }

    it 'should return a result with status of Rejected' do
      result = client.create_order(agris_new_order)

      expect(result.status).to eq 'Rejected'
    end
  end

  context 'when the post is processed' do
    let(:fixture_file) { 'create_order_processed.xml' }
    context 'with the default dataset' do
      let(:fixture_file) { 'create_order_processed.xml' }

      it 'should return a result with status of Processed' do
        result = client.create_order(agris_new_order)

        expect(result.status).to eq 'Processed'
      end
    end

    context 'with a new  dataset' do
      let(:fixture_file) { 'create_order_processed_new_dataset.xml' }

      let!(:client) do
        options = {
          logger: Logger.new(STDOUT),
          request_type: Agris::SavonRequest
        }
        Agris::Client.new(
          context,
          Agris::Credentials::Anonymous.new,
          '007',
          options
        )
      end

      it 'should return a result with status of Processed' do
        result = client.create_order(agris_new_order)

        expect(result.status).to eq 'Processed'
      end
    end
  end

  context 'when the post response contains no result' do
    let(:fixture_file) { 'create_order_no_result.xml' }

    it 'should return a result with status of No Result' do
      result = client.create_order(agris_new_order)

      expect(result.status).to eq 'No Result'
    end
  end

  # Errors before message processing
  context 'when no user id is provided' do
    let(:fixture_file) { 'process_message_user_id_error.xml' }

    it 'should fail' do
      expect { client.orders_changed_since(Time.now) }
        .to raise_error(Agris::ApiError, 'Invalid User ID Code')
    end
  end

  context 'when document tracking is not enabled' do
    let(:fixture_file) { 'process_message_document_tracking_error.xml' }

    it 'should fail' do
      expect { client.orders_changed_since(Time.now) }
        .to raise_error(Agris::ApiError, 'Not tracking document type - SORDR')
    end
  end

  # Errors during message processing
  context 'when an exception occurs' do
    let(:fixture_file) { 'process_message_exception.xml' }

    it 'should fail' do
      expect { client.orders_changed_since(Time.now) }
        .to raise_error(Agris::MessageError)
    end
  end

  # System error
  context 'when an unexpected exception occurs' do
    let(:fixture_file) { 'process_message_unexpected_exception.xml' }

    it 'should fail' do
      expect { client.orders_changed_since(Time.now) }
        .to raise_error(Agris::SystemError)
    end
  end
end
