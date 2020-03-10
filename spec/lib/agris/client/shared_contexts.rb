# frozen_string_literal: true
shared_context 'test agris client' do
  let(:client) do
    options = {
      logger: Logger.new(STDOUT),
      request_type: Agris::SavonRequest
    }
    Agris::Client.new(
      context,
      Agris::Credentials::Anonymous.new,
      '001',
      options
    )
  end
  let(:context) do
    Agris::Context.new('http://test.local', '001', 'userid', 'password')
  end
end
