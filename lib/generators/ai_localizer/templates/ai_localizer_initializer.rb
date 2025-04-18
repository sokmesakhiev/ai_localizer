# frozen_string_literal: true

AiLocalizer.configure do |config|
  # Source language iso
  config.source_lang = Figaro.env.SOURCE_LANG || 'en'

  # Target languages iso
  config.target_langs = Figaro.env.TARGET_LANGS || '[]'

  # Formality
  # Options: 'formal', 'informal'
  config.formality = Figaro.env.FORMALITY

  # Translation length intensity
  # Options: 'soft', 'strict'
  config.translation_length_intensity = Figaro.env.TRANSLATION_LENGTH_INTENSITY

  # Max translation length ratio
  config.max_translation_length_ratio = Figaro.env.MAX_TRANSLATION_LENGTH_RATIO

  # Translator engine
  # Options: 'bedrock', 'anthropic', 'deepseek', 'open_ai'
  config.translator_engine = Figaro.env.TRANSLATOR_ENGINE || 'anthropic'

  # Use existing translations
  # Options: true, false
  config.use_existing_translations = Figaro.env.USE_EXISTING_TRANSLATIONS

  # Source file paths to translate
  config.source_file_paths = Figaro.env.SOURCE_FILE_PATHS

  # Bedrock configuration
  config.bedrock_api_version = Figaro.env.BEDROCK_API_VERSION || 'bedrock-2023-05-31'
  config.bedrock_model = Figaro.env.BEDROCK_MODEL || 'anthropic.claude-3-5-sonnet-20240620-v1:0'
  config.bedrock_aws_region = Figaro.env.BEDROCK_AWS_REGION || 'us-east-1'
  config.bedrock_aws_access_key_id = Figaro.env.BEDROCK_AWS_ACCESS_KEY_ID
  config.bedrock_aws_secret_access_key = Figaro.env.BEDROCK_AWS_SECRET_ACCESS_KEY
  config.bedrock_aws_http_open_timeout = Figaro.env.BEDROCK_AWS_HTTP_OPEN_TIMEOUT || 60
  config.bedrock_aws_http_read_timeout = Figaro.env.BEDROCK_AWS_HTTP_READ_TIMEOUT || 120
  config.bedrock_aws_retry_limit = Figaro.env.BEDROCK_AWS_RETRY_LIMIT || 5
  config.bedrock_aws_session_token = Figaro.env.BEDROCK_AWS_SESSION_TOKEN

  # Anthropic configuration
  config.anthropic_api_key = Figaro.env.ANTHROPIC_API_KEY
  config.anthropic_api_version = Figaro.env.ANTHROPIC_API_VERSION || '2023-06-01'
  config.anthropic_model = Figaro.env.ANTHROPIC_MODEL || 'claude-3-7-sonnet-20250219'

  # Deepseek configuration
  config.deepseek_access_token = Figaro.env.DEEPSEEK_ACCESS_TOKEN
  config.deepseek_model = Figaro.env.DEEPSEEK_MODEL || 'deepseek-chat'

  # OpenAI configuration
  config.open_ai_access_token = Figaro.env.OPENAI_ACCESS_TOKEN
  config.open_ai_organization_id = Figaro.env.OPENAI_ORGANIZATION_ID
  config.open_ai_uri_base = Figaro.env.OPENAI_API_BASE || 'https://api.openai.com/v1'
  config.open_ai_model = Figaro.env.OPENAI_MODEL || 'gpt-4o'

  # Gemini configuration
  config.gemini_api_key = Figaro.env.GEMINI_API_KEY
  config.gemini_model = Figaro.env.GEMINI_MODEL || 'gemini-2.0-flash'
end
