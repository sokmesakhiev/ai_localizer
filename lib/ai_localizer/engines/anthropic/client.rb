# frozen_string_literal: true

module AiLocalizer
  module Engines
    module Anthropic
      class Client
        def initialize(client_params, request_timeout)
          @client_params = client_params
          @request_timeout = request_timeout
        end

        def translate(text:, user_prompt:, system_prompt:)
          ai_response = request.execute(system_prompt, user_prompt)

          response = AiLocalizer::Engines::Anthropic::Response.new(
            ai_response:,
            text:
          ).call

          # Pass the response and ai_response to the block if a block is given
          yield request, response, ai_response if block_given?

          response
        rescue JSON::ParserError => e
          # Pass the response as nil and ai_response to the block if a block is given and there is an error
          yield request, nil, ai_response if block_given?
          raise e
        end

        def request
          @request ||= AiLocalizer::Engines::Anthropic::Request.new(@client_params, @request_timeout)
        end
      end
    end
  end
end
