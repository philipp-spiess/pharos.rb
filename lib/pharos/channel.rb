require 'openssl'
require 'multi_json'

module Pharos
  # Trigger events on Channels
  class Channel
    attr_reader :name

    def initialize(base_url, name, client = Pharos)
      @uri = base_url.dup
      @uri.path = @uri.path
      @name = name
      @client = client
    end

    # Trigger event asynchronously using EventMachine::HttpRequest
    #
    # @param (see #trigger!)
    # @return [EM::DefaultDeferrable]
    #   Attach a callback to be notified of success (with no parameters).
    #   Attach an errback to be notified of failure (with an error parameter
    #   which includes the HTTP status code returned)
    # @raise [LoadError] unless em-http-request gem is available
    # @raise [Pharos::Error] unless the eventmachine reactor is running. You
    #   probably want to run your application inside a server such as thin
    #
    def trigger_async(receivers, data, &block)
      request = construct_event_request(receivers, data)
      request.send_async
    end

    # Trigger event
    #
    # @example
    #   begin
    #     Pharos['my-channel'].trigger!(user_id, {:some => 'data'})
    #   rescue Pharos::Error => e
    #     # Do something on error
    #   end
    #
    # @param data [Object] Event data to be triggered in javascript.
    #   Objects other than strings will be converted to JSON
    #
    # @raise [Pharos::Error] on invalid Pharos response - see the error message for more details
    # @raise [Pharos::HTTPError] on any error raised inside Net::HTTP - the original error is available in the original_error attribute
    #
    def trigger!(receivers, data)
      request = construct_event_request(receivers, data)
      request.send_sync
    end

    # Trigger event, catching and logging any errors.
    #
    # @note CAUTION! No exceptions will be raised on failure
    # @param (see #trigger!)
    #
    def trigger(receivers, data)
      trigger!(receivers, data)
    rescue Pharos::Error => e
      Pharos.logger.error("#{e.message} (#{e.class})")
      Pharos.logger.debug(e.backtrace.join("\n"))
    end

    private

    def construct_event_request(receivers, data)

      body = case data
      when String
        data # In this case we send a javascript instruction
      else
        begin
          MultiJson.encode(data)
        rescue MultiJson::DecodeError => e
          Pharos.logger.error("Could not convert #{data.inspect} into JSON")
          raise e
        end
      end

      request = {
        :to => receivers,
        :message => body
      }

      request = Pharos::Request.new(@uri.path, 'pharos', @client.secret)
      request.post('/push/#{@name}', receivers, data)
    end
  end
end
