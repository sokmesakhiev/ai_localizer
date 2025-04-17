# frozen_string_literal: true

module AiLocalizer
  module Api
    class Translator
      CHUNK_SIZE = 100

      attr_reader :texts, :from_lang, :to_lang, :engine, :formality, :max_translation_length_ratio, :translation_length_intensity

      def initialize(texts:, from_lang:, to_lang:, engine: nil, formality: nil, max_translation_length_ratio: nil, translation_length_intensity: nil)
        @texts = texts
        @from_lang = from_lang
        @to_lang = to_lang
        @engine = engine || AiLocalizer::Utils::TranslationEngineSelector.new(from_lang:, to_lang:).call
        @formality = formality
        @max_translation_length_ratio = max_translation_length_ratio
        @translation_length_intensity = translation_length_intensity
      end

      def call
        source_blocks = build_block(texts:)
        source_blocks.each_slice(CHUNK_SIZE) do |blocks|
          result = AiLocalizer::Services::TranslateChunkService.new(
            blocks:,
            from_lang:,
            to_lang:,
            engine:,
            formality:,
            max_translation_length_ratio:,
            translation_length_intensity:
          ).call

          blocks.each do |block|
            signature = block[:signature]
            block[:translation] = result[:translations][signature]
          end
        end

        source_blocks.pluck(:translation)
      end

      private

      def build_block(texts:)
        blocks = []

        texts.each_with_index do |text, index|
          blocks.push(
            {
              original: text,
              context: nil,
              entry: nil,
              existing_translation: nil,
              index: ["en", index.to_s],
              parent_index: nil,
              path: "",
              plural: nil,
              plural_count: nil,
              signature: Digest::MD5.hexdigest("#{index}#{text}")
            }
          )
        end

        blocks
      end
    end
  end
end
