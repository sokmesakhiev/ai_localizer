# frozen_string_literal: true

module AiLocalizer
  module Utils
    class TranslationEngineSelector
      attr_reader :from_lang, :to_lang

      def initialize(from_lang:, to_lang:)
        @from_lang = from_lang
        @to_lang = to_lang
      end

      def call
        engine = case AiLocalizer.config.translator_engine
                 when 'bedrock'
                   AiLocalizer::Engines::Bedrock::Engine
                 when 'anthropic'
                   AiLocalizer::Engines::Anthropic::Engine
                 when 'deepseek'
                   AiLocalizer::Engines::Deepseek::Engine
                 when 'open_ai'
                   AiLocalizer::Engines::OpenAi::Engine
                 else
                   AiLocalizer::Engines::Gemini::Engine
                 end

        engine.new(from_lang:, to_lang:)
      end
    end
  end
end
