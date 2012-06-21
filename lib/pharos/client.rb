module Pharos
  class Client

    attr_accessor :base_uri, :secret

    def initialize(options = {})
      options = {
        :base_uri => 'http://pharos.saloon.io',
      }.merge(options)
      @base_uri, @secret = options.values_at(
        :base_uri, :secret
      )
    end

    def [](channel_name)
      raise ConfigurationError, 'Missing client configuration: please check that secret is configured.' unless configured?
      @channels ||= {}
      @channels[channel_name.to_s] ||= Channel.new(channel_name, base_uri, self)
    end

    private

    def configured?
      base_uri && secret
    end
  end
end
