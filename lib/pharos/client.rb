module Pharos
  class Client
    attr_accessor :scheme, :host, :port, :secret

    # Initializes the client object.
    def initialize(options = {})
      options = {
        :base_uri => 'pharos.saloon.io',
      }.merge(options)
      @base_uri, @secret = options.values_at(
        :base_uri, :secret
      )
    end

    # Return a channel by name
    #
    # @example
    #   Pharos['my-channel']
    # @return [Channel]
    # @raise [ConfigurationError] unless secret has been configured
    def [](channel_name)
      raise ConfigurationError, 'Missing client configuration: please check that secret is configured.' unless configured?
      @channels ||= {}
      @channels[channel_name.to_s] ||= Channel.new(@base_uri, channel_name, self)
    end

    private

    def configured?
      base_uri && secret
    end
  end
end
