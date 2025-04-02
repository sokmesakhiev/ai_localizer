# frozen_string_literal: true

module AiLocalizer
  module Engines
    module Deepseek
      class Request
        attr_reader :access_token, :model

        def initialize(client_params)
          @access_token = client_params[:access_token]
          @model = client_params[:model]
        end

        def execute(system_prompt, user_prompt)
          response = deepseek_client.chat(
            model:,
            messages: [
              { role: 'system', content: system_prompt },
              { role: 'user', content: user_prompt }
            ]
          )
        end

        def deepseek_client
          @deepseek_client ||= ::Deepseek::Client.new(api_key: access_token)
        end
      end
    end
  end
end
