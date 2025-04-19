# frozen_string_literal: true

config_path = Rails.root.join('config', 'ai_localizer.yml')
raw_config = YAML.load_file(config_path, aliases: true)
AI_LOCALIZER_CONFIG = raw_config[Rails.env] || {}

AiLocalizer.configure do |config|
  # Source language iso
  config.source_lang = SOURCE_LANG || 'en'

  # Target languages iso
  config.target_langs = AI_LOCALIZER_CONFIG['TARGET_LANGS'] || []

  # Formality
  # Options: 'formal', 'informal'
  config.formality = AI_LOCALIZER_CONFIG['FORMALITY']

  # Translation length intensity
  # Options: 'soft', 'strict'
  config.translation_length_intensity = AI_LOCALIZER_CONFIG['TRANSLATION_LENGTH_INTENSITY']

  # Max translation length ratio
  config.max_translation_length_ratio = AI_LOCALIZER_CONFIG['MAX_TRANSLATION_LENGTH_RATIO']

  # Translator engine
  # Options: 'bedrock', 'anthropic', 'deepseek', 'open_ai'
  config.translator_engine = AI_LOCALIZER_CONFIG['TRANSLATOR_ENGINE'] || 'anthropic'

  # Use existing translations
  # Options: true, false
  config.use_existing_translations = AI_LOCALIZER_CONFIG['USE_EXISTING_TRANSLATIONS']

  # Source file paths to translate
  config.source_file_paths = JSON.parse(AI_LOCALIZER_CONFIG['SOURCE_FILE_PATHS']) || []

  # Bedrock configuration
  config.bedrock_api_version = AI_LOCALIZER_CONFIG['BEDROCK_API_VERSION'] || 'bedrock-2023-05-31'
  config.bedrock_model = AI_LOCALIZER_CONFIG['BEDROCK_MODEL'] || 'anthropic.claude-3-5-sonnet-20240620-v1:0'
  config.bedrock_aws_region = AI_LOCALIZER_CONFIG['BEDROCK_AWS_REGION'] || 'us-east-1'
  config.bedrock_aws_access_key_id = AI_LOCALIZER_CONFIG['BEDROCK_AWS_ACCESS_KEY_ID']
  config.bedrock_aws_secret_access_key = AI_LOCALIZER_CONFIG['BEDROCK_AWS_SECRET_ACCESS_KEY']
  config.bedrock_aws_http_open_timeout = AI_LOCALIZER_CONFIG['BEDROCK_AWS_HTTP_OPEN_TIMEOUT'] || 60
  config.bedrock_aws_http_read_timeout = AI_LOCALIZER_CONFIG['BEDROCK_AWS_HTTP_READ_TIMEOUT'] || 120
  config.bedrock_aws_retry_limit = AI_LOCALIZER_CONFIG['BEDROCK_AWS_RETRY_LIMIT'] || 5
  config.bedrock_aws_session_token = AI_LOCALIZER_CONFIG['BEDROCK_AWS_SESSION_TOKEN']

  # Anthropic configuration
  config.anthropic_api_key = AI_LOCALIZER_CONFIG['ANTHROPIC_API_KEY']
  config.anthropic_api_version = AI_LOCALIZER_CONFIG['ANTHROPIC_API_VERSION'] || '2023-06-01'
  config.anthropic_model = AI_LOCALIZER_CONFIG['ANTHROPIC_MODEL'] || 'claude-3-7-sonnet-20250219'

  # Deepseek configuration
  config.deepseek_access_token = AI_LOCALIZER_CONFIG['DEEPSEEK_ACCESS_TOKEN']
  config.deepseek_model = AI_LOCALIZER_CONFIG['DEEPSEEK_MODEL'] || 'deepseek-chat'

  # OpenAI configuration
  config.open_ai_access_token = AI_LOCALIZER_CONFIG['OPENAI_ACCESS_TOKEN']
  config.open_ai_organization_id = AI_LOCALIZER_CONFIG['OPENAI_ORGANIZATION_ID']
  config.open_ai_uri_base = AI_LOCALIZER_CONFIG['OPENAI_API_BASE'] || 'https://api.openai.com/v1'
  config.open_ai_model = AI_LOCALIZER_CONFIG['OPENAI_MODEL'] || 'gpt-4o'

  # Gemini configuration
  config.gemini_api_key = AI_LOCALIZER_CONFIG['GEMINI_API_KEY']
  config.gemini_model = AI_LOCALIZER_CONFIG['GEMINI_MODEL'] || 'gemini-2.0-flash'
end
