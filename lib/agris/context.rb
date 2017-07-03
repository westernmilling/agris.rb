# frozen_string_literal: true
module Agris
  Context = Struct.new(
    :base_url, :dataset, :datapath, :database, :userid, :password
  )
end
