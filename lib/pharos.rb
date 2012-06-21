require 'uri'
require 'forwardable'

require 'pharos/client'

# Used for configuring API credentials and creating Channel objects
#
module Pharos

  class ConfigurationError < Error; end

  class << self
    extend Forwardable

    def_delegators :default_client, :base_uri, :secret
    def_delegators :default_client, :base_uri=, :secret=

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

    private

    def default_client
      @default_client ||= Pharos::Client.new
    end
  end
end

require 'pharos/channel'
