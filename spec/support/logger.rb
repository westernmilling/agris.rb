# frozen_string_literal: true
RSpec.configure do |config|
  config.before(:each) do
    allow(Logger).to receive(:new).and_return(spy)
  end
end
