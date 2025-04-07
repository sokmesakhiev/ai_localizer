# frozen_string_literal: true

module AiLocalizer
  module Services
    class TranslateChunkService
      attr_reader :file_path, :from_lang, :to_lang, :engine, :indicator, :text, :original_text, :failed_translations

      def initialize(blocks:, from_lang:, to_lang:, engine:)
        @blocks = blocks
        @from_lang = from_lang
        @to_lang = to_lang
        @engine = engine
        @text = blocks.to_h { |tm| [tm[:signature], tm[:original]] }
        @original_text = text&.transform_values(&:dup)
        @failed_translations = []
      end

      def self.call(**args)
        new(**args).call
      end

      def call
        # preprocess
        for_translation, processing_additional_data = preprocess_chunk(text)

        translated = perform_translation(for_translation)
        validate_translation_count(translated.count, for_translation.count)
        translations = for_translation.each_with_index.to_h { |(signature, _segment), index| [signature, translated[index]] }

        # postprocess
        translations = postprocess_chunk(translations, processing_additional_data)

        {
          translations:,
          not_translated: @original_text.slice(*failed_translations)
        }
      end

      private

      def preprocess_chunk(text)
        pre_processing_additional_data = AiLocalizer::Entities::TranslationConfiguration.new(
          placeholder_formats:,
          from: from_lang,
          to: to_lang,
          engine:
        )

        processed_chunk = text.to_h do |signature, segment|
          [
            signature,
            preprocessor.process_all(source: segment, signature:, additional_data: pre_processing_additional_data)
          ]
        end

        [processed_chunk, pre_processing_additional_data]
      end

      def postprocess_chunk(translations, additional_data)
        processed_translations = translations.to_h do |signature, translation|
          processed_translation = postprocessor.process_all(source: original_text[signature], translation:, signature:, additional_data:)
          @failed_translations << signature if additional_data.failed?(id: signature)
          [signature, processed_translation]
        end
      end

      def perform_translation(for_translation)
        translated = []
        texts = for_translation.values

        strings = texts.select { |t| t.is_a?(String) }
        chunks = chunk_array(strings)
        chunks.each do |chunk|
          translations = engine.translate(text: chunk)

          translations = [''] * chunk.size if translations.nil?
          translations = [translations] if translations.is_a?(String)
          translated += translations
        end

        translated
      end

      def chunk_array(strings, limit = 4000)
        chunks = []
        current_chunk = []
        current_length = 0

        strings.each do |string|
          # Include the length of the string plus a space for separation
          new_length = current_length + string.length + 1

          # If adding the string exceeds the limit, start a new chunk
          if new_length > limit
            chunks << current_chunk
            current_chunk = [string]
            current_length = string.length
          else
            current_chunk << string
            current_length = new_length
          end
        end

        # Add the last chunk if it's not empty
        chunks << current_chunk unless current_chunk.empty?

        chunks
      end

      def placeholder_formats
        AiLocalizer::Entities::Placeholders::DEFAULT_PLACEHOLDERS
      end

      def validate_translation_count(translated_count, for_translation_count)
        return if translated_count == for_translation_count

        puts 'We got invalid number of strings from translation engine'
      end

      def postprocessor
        @postprocessor ||= AiLocalizer::Processors::Post.new
      end

      def preprocessor
        @preprocessor ||= AiLocalizer::Processors::Pre.new
      end
    end
  end
end
