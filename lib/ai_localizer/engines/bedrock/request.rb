# frozen_string_literal: true

module AiLocalizer
  module Engines
    module Bedrock
      class Request
        attr_reader :api_version, :model_id, :max_tokens, :region, :access_key_id, :secret_access_key,
                    :http_open_timeout, :http_read_timeout, :retry_limit, :session_token

        def initialize(client_params)
          @model_id = client_params[:model]
          @max_tokens = client_params[:max_tokens].to_i
          @api_version = client_params[:api_version]
          @region = client_params[:region]
          @access_key_id = client_params[:access_key_id]
          @secret_access_key = client_params[:secret_access_key]
          @http_open_timeout = client_params[:http_open_timeout]
          @http_read_timeout = client_params[:http_read_timeout]
          @retry_limit = client_params[:retry_limit]
          @session_token = client_params[:session_token]
        end

        def execute(system_prompt, user_prompt)
          client = ::Aws::BedrockRuntime::Client.new(client_config)

          body = {
            anthropic_version: api_version,
            max_tokens:,
            system: system_prompt,
            messages: [{ role: 'user', content: user_prompt }]
          }.to_json

          body.bytesize

          response = client.invoke_model(
            {
              model_id:,
              content_type: 'application/json',
              body:
            }
          )

          JSON.parse(response.body.read)
        end

        private

        def client_config
          return @client_config if @client_config.present?

          @client_config = {
            region:,
            http_open_timeout:,
            http_read_timeout:,
            retry_limit:
          }

          if access_key_id.present? && secret_access_key.present?
            @client_config[:access_key_id] = access_key_id
            @client_config[:secret_access_key] = secret_access_key
            @client_config[:session_token] = @session_token if @session_token.present?
          end

          @client_config
        end
      end
    end
  end
end
