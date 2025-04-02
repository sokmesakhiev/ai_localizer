# frozen_string_literal: true

module AiLocalizer
  module Engines
    module Deepseek
      class Engine < AiLocalizer::Engines::BaseEngine
        def service_name
          'Deepseek'
        end

        private

        def client
          AiLocalizer::Engines::Deepseek::Client.new(client_params)
        end

        def client_params
          {
            access_token: AiLocalizer.config.deepseek_access_token,
            model: AiLocalizer.config.deepseek_model
          }
        end
      end
    end
  end
end
