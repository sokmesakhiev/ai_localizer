# frozen_string_literal: true

module AiLocalizer
  module Engines
    module OpenAi
      class Engine < AiLocalizer::Engines::BaseEngine
        def service_name
          'OpenAI'
        end

        private

        def client
          @client ||= AiLocalizer::Engines::OpenAi::Client.new(client_params)
        end

        def client_params
          {
            open_ai_access_token: AiLocalizer.config.open_ai_access_token,
            open_ai_model: AiLocalizer.config.open_ai_model,
            open_ai_organization_id: AiLocalizer.config.open_ai_organization_id,
            open_ai_uri_base: AiLocalizer.config.open_ai_uri_base
          }
        end
      end
    end
  end
end
