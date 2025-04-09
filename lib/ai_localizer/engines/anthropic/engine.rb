# frozen_string_literal: true

module AiLocalizer
  module Engines
    module Anthropic
      class Engine < AiLocalizer::Engines::BaseEngine
        REQUEST_TIMEOUT = 120

        private

        def client
          Engines::Anthropic::Client.new(client_params, REQUEST_TIMEOUT)
        end

        def client_params
          {
            access_token: AiLocalizer.config.anthropic_api_key,
            api_version: AiLocalizer.config.anthropic_api_version,
            model: AiLocalizer.config.anthropic_model,
            max_tokens: MAX_OUTPUT_TOKENS
          }
        end
      end
    end
  end
end
