# frozen_string_literal: true

# Builds an Agris::Client whose request type is a double, so client specs can
# assert on the ProcessMessage arguments without any SOAP traffic. Call the
# methods explicitly (StubbedAgrisClient.stubbed_agris_client) from inside an
# example; the RSpec mock helpers they use only work while one is running.
module StubbedAgrisClient
  extend RSpec::Mocks::ExampleMethods

  def self.processed_response(document)
    double(
      'response',
      output_hash: {
        'results' => {
          'result' => {
            'status' => 'Processed',
            'document' => document,
            'rejects' => { 'reject' => [] }
          }
        }
      }
    )
  end

  # Returns the client and the request double it will call.
  def self.stubbed_agris_client(response)
    request_instance = double('request', process_message: response)
    request_class = Class.new
    allow(request_class).to receive(:new).and_return(request_instance)

    context = Agris::Context.new(
      'http://test.local',
      '001',
      '\\\\host\\datasets',
      'AgrisDB',
      'bob',
      'fred'
    )
    client = Agris::Client.new(
      context,
      Agris::Credentials::Anonymous.new,
      { request_type: request_class },
      dataset: '001'
    )

    [client, request_instance]
  end
end
