require "ai_localizer/version"
require 'ostruct'
require 'pry'
require 'yaml'
require 'json'
require 'openai'
require 'oj'
require 'figaro'
require 'anthropic'
require 'aws-sdk-bedrockruntime'
require 'deepseek'

require_relative './ai_localizer/configuration'

require_relative './ai_localizer/processors/pre'
require_relative './ai_localizer/processors/post'

require_relative './ai_localizer/api/translator'

require_relative './ai_localizer/services/create_translation_file_service'
require_relative './ai_localizer/services/file_translator_service'
require_relative './ai_localizer/services/translate_chunk_service'

require_relative './ai_localizer/utils/placeholder_processor'
require_relative './ai_localizer/utils/tokenizer'
require_relative './ai_localizer/utils/prompt_builder'
require_relative './ai_localizer/utils/yml_parser'
require_relative './ai_localizer/utils/yml_formatter'
require_relative './ai_localizer/utils/flatten_hash'
require_relative './ai_localizer/utils/recovery'
require_relative './ai_localizer/utils/line_by_line'
require_relative './ai_localizer/utils/signature_generator'
require_relative './ai_localizer/utils/translation_engine_selector'
require_relative './ai_localizer/utils/file_name_pattern'
require_relative './ai_localizer/utils/import_existing_translation'

require_relative './ai_localizer/entities/placeholders'
require_relative './ai_localizer/entities/source_block'
require_relative './ai_localizer/entities/language'
require_relative './ai_localizer/entities/translation_configuration'

require_relative './ai_localizer/engines/base_engine'
require_relative './ai_localizer/engines/base_response'
require_relative './ai_localizer/engines/bedrock/engine'
require_relative './ai_localizer/engines/bedrock/client'
require_relative './ai_localizer/engines/bedrock/request'
require_relative './ai_localizer/engines/bedrock/response'
require_relative './ai_localizer/engines/anthropic/engine'
require_relative './ai_localizer/engines/anthropic/client'
require_relative './ai_localizer/engines/anthropic/request'
require_relative './ai_localizer/engines/anthropic/response'
require_relative './ai_localizer/engines/open_ai/engine'
require_relative './ai_localizer/engines/open_ai/client'
require_relative './ai_localizer/engines/open_ai/request'
require_relative './ai_localizer/engines/open_ai/response'
require_relative './ai_localizer/engines/deepseek/engine'
require_relative './ai_localizer/engines/deepseek/client'
require_relative './ai_localizer/engines/deepseek/request'
require_relative './ai_localizer/engines/deepseek/response'

module AiLocalizer
  Dotenv.load
  configure {}

  def self.create_locales(template_file_path:, from_lang:, to_langs:, indicator: nil, use_existing_translations: true)
    to_langs.each do |to_lang|
      engine = translation_engine(from_lang:, to_lang:)

      next if engine.blank? || template_file_path.blank?

      translations = AiLocalizer::Services::FileTranslatorService.new(
        template_file_path:,
        from_lang:,
        to_lang:,
        engine:,
        indicator:
      )
    end
  end

  def self.translation_engine(from_lang:, to_lang:)
    @translation_engine ||= AiLocalizer::Utils::TranslationEngineSelector.new(from_lang:, to_lang:).call
  end
end
