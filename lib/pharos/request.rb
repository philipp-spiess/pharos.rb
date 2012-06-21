require 'httparty'

module Pharos
  class Request
    include HTTParty

      def initialize(uri, username, password) 
        @base_uri = uri
        @auth = { username: username, password: password }
      end  

      def post(path, to, message)
        options = { query: { to: to, :message message }, basic_auth: @auth}
        self.class.post(path, options)
      end

  end
end
