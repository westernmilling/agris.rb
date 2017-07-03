# frozen_string_literal: true
RSpec.configure do |config|
  config.before(:all, agris_api_mock: true) do
    savon.unmock!
  end

  config.before(:all, agris_api_mock: true) do
    savon.mock!
  end

  config.before(:each, agris_api_mock: true) do
    wsdl = File.read(
      File.join(
        %w(
          ./
          spec
          fixtures
          agris
          Web_Service.wsdl
        )
      )
    )
    stub_request(
      :get,
      %r(agris\/AGRIS.Env.MessageRouter\/AGRIS.Env.MessageRouter.asmx\?WSDL)
    ).to_return(status: 200, body: wsdl)
  end
end
