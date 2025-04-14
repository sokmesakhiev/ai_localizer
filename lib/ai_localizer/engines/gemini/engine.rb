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
            gemini_access_token: AiLocalizer.config.open_ai_access_token,
            gemini_model: AiLocalizer.config.open_ai_model,
          }
        end
      end
    end
  end
end
