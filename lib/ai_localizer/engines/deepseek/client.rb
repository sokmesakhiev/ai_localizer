# frozen_string_literal: true

module AiLocalizer
  module Engines
    module Deepseek
      class Client
        def initialize(client_params)
          @client_params = client_params
        end

        def translate(text:, user_prompt:, system_prompt:)
          ai_response = request.execute(system_prompt, user_prompt)

          response = AiLocalizer::Engines::Deepseek::Response.new(
            ai_response:,
            text:
          ).call

          response
        rescue JSON::ParserError => e
          raise e
        end

        def request
          @request ||= AiLocalizer::Engines::Deepseek::Request.new(@client_params)
        end
      end
    end
  end
end
