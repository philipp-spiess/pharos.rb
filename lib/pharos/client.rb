module Pharos
  class Client
    attr_accessor :scheme, :host, :port, :secret

    # Initializes the client object.
    def initialize(options = {})
      options = {
        :scheme => 'http',
        :host => 'pharos.saloon.io',
        :port => 80,
      }.merge(options)
      @scheme, @host, @port, @secret = options.values_at(
        :scheme, :host, :port, :secret
      )
    end

    # @private Builds a connection url for Pharos
    def url
      URI::Generic.build({
        :scheme => @scheme,
        :host => @host,
        :port => @port
      })
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
      @channels[channel_name.to_s] ||= Channel.new(url, channel_name, self)
    end

    private

    def configured?
      host && scheme && secret
    end
  end
end
