# frozen_string_literal: true

module AiLocalizer
  module Engines
    module Bedrock
      class Engine < AiLocalizer::Engines::BaseEngine
        def service_name
          'AWSBedrock'
        end

        private

        def client
          @client ||= AiLocalizer::Engines::Bedrock::Client.new(client_params)
        end

        def client_params
          {
            api_version: AiLocalizer.config.bedrock_api_version,
            model: AiLocalizer.config.bedrock_model,
            region: AiLocalizer.config.bedrock_aws_region,
            access_key_id: AiLocalizer.config.bedrock_aws_access_key_id,
            secret_access_key: AiLocalizer.config.bedrock_aws_secret_access_key,
            http_open_timeout: AiLocalizer.config.bedrock_aws_http_open_timeout,
            http_read_timeout: AiLocalizer.config.bedrock_aws_http_read_timeout,
            retry_limit: AiLocalizer.config.bedrock_aws_retry_limit,
            session_token: AiLocalizer.config.bedrock_aws_session_token,
            max_tokens: MAX_OUTPUT_TOKENS
          }
        end
      end
    end
  end
end
