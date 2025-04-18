# frozen_string_literal: true

require 'rails/generators'

module AiLocalizer
  class Configuration
    attr_accessor :translator_engine, :bedrock_api_version, :bedrock_model, :bedrock_aws_region,
                  :bedrock_aws_access_key_id, :bedrock_aws_secret_access_key, :bedrock_aws_http_open_timeout,
                  :bedrock_aws_http_read_timeout, :bedrock_aws_retry_limit, :bedrock_aws_session_token,
                  :anthropic_api_key, :anthropic_api_version, :anthropic_model, :deepseek_access_token,
                  :deepseek_model, :source_file_paths, :open_ai_access_token, :open_ai_model,
                  :open_ai_organization_id, :open_ai_uri_base, :gemini_api_key, :gemini_model, :use_existing_translations,
                  :source_lang, :target_langs, :formality, :translation_length_intensity, :max_translation_length_ratio

    def initialize
      @source_lang = 'en'
      @target_langs = ['es', 'fr']
      @formality = nil
      @translation_length_intensity = nil
      @max_translation_length_ratio = nil
      @use_existing_translations = true

      @translator_engine = 'gemini'
      @source_file_paths = []

      @bedrock_api_version = 'bedrock-2023-05-31'
      @bedrock_model = 'anthropic.claude-3-5-sonnet-20240620-v1:0'
      @bedrock_aws_region = 'us-east-1'
      @bedrock_aws_access_key_id = ENV['BEDROCK_AWS_ACCESS_KEY_ID']
      @bedrock_aws_secret_access_key = ENV['BEDROCK_AWS_SECRET_ACCESS_KEY']
      @bedrock_aws_http_open_timeout = 60
      @bedrock_aws_http_read_timeout = 120
      @bedrock_aws_retry_limit = 10
      @bedrock_aws_sesion_token = nil

      @anthropic_api_key = ENV['ANTHROPIC_API_KEY']
      @anthropic_api_version = '2023-06-01'
      @anthropic_model = 'claude-3-7-sonnet-20250219'

      @open_ai_access_token = ENV['OPEN_AI_ACCESS_TOKEN']
      @open_ai_model = 'gpt-4o'
      @open_ai_organization_id = ''
      @open_ai_uri_base = 'https://api.openai.com/v1'

      # @gemini_api_key = ENV['GEMINI_API_KEY']
      @gemini_api_key = 'AIzaSyCWHswF1BBnxKnV9W7vhzhyd8_tv3h4kC8'
      @gemini_model = 'gemini-2.0-flash'

      @deepseek_access_token = ENV['DEEPSEEK_ACCESS_TOKEN']
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
