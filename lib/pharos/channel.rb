require 'httparty'
require 'multi_json'

module Pharos
  class Channel
    
    include HTTParty

    attr_reader :name

    def initialize(name, client = Pharos)
      @name = name
      @path = "/push/{name}/"
      @base_uri = client.base_uri
      @client = client
      @auth = { username: 'pharos', password: client.secret }
    end

    def push(receivers, data)
      body = case data
      when String
        data # In this case we send a javascript instruction
      else
        begin
          MultiJson.encode(data)
        rescue MultiJson::DecodeError => e
          raise e
        end
      end

      options = { query: { to: receivers, message: body }, basic_auth: @auth}
      self.class.post(@path, options)
    end
  end
end
