# frozen_string_literal: true

require 'agris/version'

module Agris
  USER_AGENT = Agris.user_agent.to_s + " (Agris.rb #{VERSION})"
end
