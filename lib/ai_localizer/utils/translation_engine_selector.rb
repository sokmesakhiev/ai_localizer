# frozen_string_literal: true

module AiLocalizer
  module Utils
    class TranslationEngineSelector
      attr_reader :from_lang, :to_lang, :engine_type

      def self.call(**args)
        new(**args).call
      end

      def initialize(engine_type:, from_lang:, to_lang:)
        @from_lang = from_lang
        @to_lang = to_lang
        @engine_type = engine_type
      end

      def call
        engine = case engine_type
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
