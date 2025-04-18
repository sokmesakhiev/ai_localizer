require 'ai_localizer/version'
require 'ostruct'
require 'yaml'
require 'json'
require 'openai'
require 'oj'
require 'anthropic'
require 'aws-sdk-bedrockruntime'
require 'deepseek'

require_relative './ai_localizer/configuration'

require_relative './ai_localizer/processors/pre'
require_relative './ai_localizer/processors/post'

require_relative './ai_localizer/api/translator'

require_relative './ai_localizer/services/base'
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
require_relative './ai_localizer/engines/gemini/engine'
require_relative './ai_localizer/engines/gemini/client'
require_relative './ai_localizer/engines/gemini/request'
require_relative './ai_localizer/engines/gemini/response'

module AiLocalizer
  configure {}

  def self.create_locales(template_file_path:)
    from_lang = AiLocalizer.config.source_lang
    to_langs = AiLocalizer.config.target_langs
    engine_type = AiLocalizer.config.translator_engine

    to_langs.each do |to_lang|
      file_name_pattern = AiLocalizer::Utils::FileNamePattern.new(template_file_path:, from_lang:, to_lang:)
      file_path = file_name_pattern.source_file_path

      print "\e[31m --> Translating file #{file_path} from #{from_lang} to #{to_lang} .. \e[0m \n"

      engine = AiLocalizer::Utils::TranslationEngineSelector.call(engine_type:, from_lang:, to_lang:)

      next if engine.blank? || template_file_path.blank?

      AiLocalizer::Services::FileTranslatorService.call(
        template_file_path:,
        engine:,
        translation_settings: translation_settings.merge(from_lang:, to_lang:)
      )

      print "\e[32m --> Translation done #{file_path} from #{from_lang} to #{to_lang} .. \e[0m \n\n"
    end
  end

  def self.translation_settings
    {
      formality: AiLocalizer.config.formality,
      translation_length_intensity: AiLocalizer.config.translation_length_intensity,
      max_translation_length_ratio: AiLocalizer.config.max_translation_length_ratio,
      use_existing_translations: AiLocalizer.config.use_existing_translations
    }
  end
end
