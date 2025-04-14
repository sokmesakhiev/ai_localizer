# frozen_string_literal: true

module AiLocalizer
  module Engines
    module Gemini
      class Client
        def initialize(client_params)
          @client_params = client_params
        end

        def translate(text:, user_prompt:, system_prompt:)
          ai_response = request.execute(system_prompt, user_prompt)

          response = AiLocalizer::Engines::Gemini::Response.new(
            ai_response:,
            text:
          ).call

          yield request, response, ai_response if block_given? # Pass the response and ai_response to the block if a block is given

          response
        end

        def request
          @request ||= AiLocalizer::Engines::Gemini::Request.new(@client_params)
        end
      end
    end
  end
end
