# frozen_string_literal: true

require 'rails/generators'

module AiLocalizer
  class Configuration
    attr_accessor :translator_engine, :bedrock_api_version, :bedrock_model, :bedrock_aws_region,
                  :bedrock_aws_access_key_id, :bedrock_aws_secret_access_key, :bedrock_aws_http_open_timeout,
                  :bedrock_aws_http_read_timeout, :bedrock_aws_retry_limit, :bedrock_aws_session_token,
                  :anthropic_api_key, :anthropic_api_version, :anthropic_model, :deepseek_access_token,
                  :deepseek_model, :source_file_paths, :open_ai_access_token, :open_ai_model,
                  :open_ai_organization_id, :open_ai_uri_base

    def initialize
      @translator_engine = 'anthropic'
      @source_file_paths = []

      @bedrock_api_version = 'bedrock-2023-05-31'
      @bedrock_model = 'anthropic.claude-3-5-sonnet-20240620-v1:0'
      @bedrock_aws_region = 'us-east-1'
      @bedrock_aws_access_key_id = 'AKIAXTKWXSI3CPDEY3WG'
      @bedrock_aws_secret_access_key = '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'
      @bedrock_aws_http_open_timeout = 60
      @bedrock_aws_http_read_timeout = 120
      @bedrock_aws_retry_limit = 10
      @bedrock_aws_session_token = nil

      @anthropic_api_key = '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'
      @anthropic_api_version = '2023-06-01'
      @anthropic_model = 'claude-3-5-sonnet-20240620'

      @open_ai_access_token = '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'
      @open_ai_model = 'gpt-4o'
      @open_ai_organization_id = ''
      @open_ai_uri_base = 'https://api.openai.com/v1'

      @deepseek_access_token = 'sk-867cea1177cb46a6b60153c033cdc6d1'
      @deepseek_model = 'deepseek-chat'
    end
  end

  class << self
    attr_accessor :config

    def configure
      self.config ||= Configuration.new
      yield(config)
    end
  end
end
