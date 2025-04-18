# frozen_string_literal: true

module AiLocalizer
  module Engines
    module OpenAi
      class Request
        attr_reader :access_token, :model, :uri_base, :organization_id

        def initialize(client_params)
          @access_token = client_params[:open_ai_access_token]
          @model = client_params[:open_ai_model]
          @uri_base = client_params[:open_ai_uri_base]
          @organization_id = client_params[:open_ai_organization_id]
        end

        def execute(system_prompt, user_prompt)
          open_ai_client.chat(
            parameters: {
              model:,
              messages: [
                { role: 'system', content: system_prompt },
                { role: 'user', content: user_prompt }
              ]
            }
          )
        end

        def open_ai_client
          OpenAI.configure do |config|
            config.access_token = access_token
            config.organization_id = organization_id
            config.uri_base = uri_base
          end

          OpenAI::Client.new
        end
      end
    end
  end
end
