# frozen_string_literal: true
module Agris
  Context = Struct.new(
    :base_url, :default_dataset, :datapath, :database, :userid, :password
  )
end
