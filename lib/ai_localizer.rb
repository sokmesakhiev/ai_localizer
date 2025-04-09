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
  configure {}

  def self.create_locales(template_file_path:)
    from_lang = AiLocalizer.config.source_lang
    to_langs = JSON.parse(AiLocalizer.config.target_langs)

    to_langs.each do |to_lang|
      print "\e[31m --> Translating file #{path} from #{from_lang} to #{to_lang} .. \e[0m \n"

      engine = AiLocalizer::Utils::TranslationEngineSelector.new(from_lang:, to_lang:).call

      next if engine.blank? || template_file_path.blank?

      translations = AiLocalizer::Services::FileTranslatorService.new(
        template_file_path:,
        engine:,
        translation_settings: translation_settings.merge(from_lang:, to_lang:)
      ).call

      print "\e[32m --> Translation done #{path} from #{from_lang} to #{to_lang} .. \e[0m \n"
    end

    print "\e[32m --> Done  .. \n\n"
  end

  def translation_settings
    {
      formality: AiLocalizer.config.formality,
      translation_length_intensity: AiLocalizer.config.translation_length_intensity,
      max_translation_length_ratio: AiLocalizer.config.max_translation_length_ratio
    }
  end
end
