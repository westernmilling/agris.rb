# frozen_string_literal: true
module Agris
  module Credentials
    autoload :Anonymous, "agris/credentials/anonymous"
    autoload :BasicAuth, "agris/credentials/basic_auth"
  end
end
