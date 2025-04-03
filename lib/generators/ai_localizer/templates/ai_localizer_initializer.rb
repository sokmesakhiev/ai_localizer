# frozen_string_literal: true

AiLocalizer.configure do |config|
  # Translator engine
  # Options: 'bedrock', 'anthropic', 'deepseek', 'open_ai'
  config.translator_engine = Figaro.env.fetch("TRANSLATOR_ENGINE", 'anthropic')

  # Source file paths to translate
  config.source_file_paths = Figaro.env.fetch("SOURCE_FILE_PATHS", nil)

  # Bedrock configuration
  config.bedrock_api_version = Figaro.env.fetch("BEDROCK_API_VERSION", 'bedrock-2023-05-31')
  config.bedrock_model = Figaro.env.fetch("BEDROCK_MODEL", 'anthropic.claude-3-5-sonnet-20240620-v1:0')
  config.bedrock_aws_region = Figaro.env.fetch("BEDROCK_AWS_REGION", 'us-east-1')
  config.bedrock_aws_access_key_id = Figaro.env.fetch("BEDROCK_AWS_ACCESS_KEY_ID", nil)
  config.bedrock_aws_secret_access_key = Figaro.env.fetch("BEDROCK_AWS_SECRET_ACCESS_KEY", nil)
  config.bedrock_aws_http_open_timeout = Figaro.env.fetch("AWS_BEDROCK_HTTP_OPEN_TIMEOUT", 60)
  config.bedrock_aws_http_read_timeout = Figaro.env.fetch("AWS_BEDROCK_HTTP_READ_TIMEOUT", 120)
  config.bedrock_aws_retry_limit = Figaro.env.fetch("AWS_BEDROCK_RETRY_LIMIT", 5)
  config.bedrock_aws_session_token = Figaro.env.fetch("AWS_BEDROCK_SESSION_TOKEN", nil)

  # Anthropic configuration
  config.anthropic_api_key = Figaro.env.fetch("ANTHROPIC_API_KEY", nil)
  config.anthropic_api_version =  Figaro.env.fetch("ANTHROPIC_API_VERSION", '2023-06-01')
  config.anthropic_model = Figaro.env.fetch("ANTHROPIC_MODEL", 'claude-3-5-sonnet-20240620')

  # Deepseek configuration
  config.deepseek_access_token = Figaro.env.fetch("DEEPSEEK_ACCESS_TOKEN",nil)
  config.deepseek_model = Figaro.env.fetch("DEEPSEEK_MODEL", 'claude-3-5-sonnet-20240620')

  # OpenAI configuration
  config.open_ai_access_token = Figaro.env.fetch("OPENAI_ACCESS_TOKEN", nil)
  config.open_ai_organization_id = Figaro.env.fetch("OPENAI_ORGANIZATION_ID", nil)
  config.open_ai_uri_base = Figaro.env.fetch("OPENAI_API_BASE", 'https://api.openai.com/v1')
  config.open_ai_model = Figaro.env.fetch("OPENAI_MODEL", 'gpt-3.5-turbo-0613')
end
