# frozen_string_literal: true

module AiLocalizer
  module Engines
    module Gemini
      class Engine < AiLocalizer::Engines::BaseEngine
        private

        def client
          @client ||= AiLocalizer::Engines::Gemini::Client.new(client_params)
        end

        def client_params
          {
            gemini_api_key: AiLocalizer.config.gemini_api_key,
            gemini_model: AiLocalizer.config.gemini_model,
          }
        end
      end
    end
  end
end
