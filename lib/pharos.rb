#autoload 'Logger', 'logger'
require 'uri'
require 'forwardable'

require 'pharos/client'

# Used for configuring API credentials and creating Channel objects
#
module Pharos

  class Error < RuntimeError; end
  class AuthenticationError < Error; end
  class ConfigurationError < Error; end
  class HTTPError < Error; attr_accessor :original_error; end

  class << self
    extend Forwardable

    def_delegators :default_client, :scheme, :host, :port, :secret
    def_delegators :default_client, :scheme=, :host=, :port=, :secret=

    attr_writer :logger

    # Return a channel by name
    #
    # @example
    #   Pharos['my-channel']
    # @return [Channel]
    # @raise [ConfigurationError] unless key, secret and app_id have been
    #   configured
    def [](channel_name)
      begin
        default_client[channel_name]
      rescue ConfigurationError
        raise ConfigurationError, 'Missing configuration: please check that Pharos.secret is configured.'
      end
    end

    def logger
      @logger ||= begin
        log = Logger.new($stdout)
        log.level = Logger::INFO
        log
      end
    end

    private

    def default_client
      @default_client ||= Pharos::Client.new
    end
  end
end

require 'pharos/channel'
require 'pharos/request'
