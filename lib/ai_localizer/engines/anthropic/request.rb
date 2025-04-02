# frozen_string_literal: true

module AiLocalizer
  module Engines
    module Anthropic
      class Request
        attr_reader :access_token, :anthropic_version, :model, :max_tokens, :request_timeout

        def initialize(client_params, request_timeout)
          @access_token = client_params[:access_token]
          @anthropic_version = client_params[:api_version]
          @model = client_params[:model]
          @max_tokens = client_params[:max_tokens].to_i
          @request_timeout = request_timeout
        end

        def execute(system_prompt, user_prompt)
          client = ::Anthropic::Client.new(
            access_token:,
            anthropic_version:,
            request_timeout:
          )

          client.messages(
            parameters: {
              model:,
              system: system_prompt,
              messages: [
                { role: 'user', content: user_prompt }
              ],
              max_tokens:
            }
          )
        end

        def request_data
          {
            request_timeout:,
            anthropic_version:,
            model:,
            max_tokens:
          }
        end
      end
    end
  end
end
