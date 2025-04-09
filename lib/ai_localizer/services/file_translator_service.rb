# frozen_string_literal: true

module AiLocalizer
  module Services
    class FileTranslatorService
      CHUNK_SIZE = 100

      attr_reader :template_file_path, :engine, :translation_settings

      # translation_settings :
      # {
      #   from_lang: 'en',
      #   to_lang: 'es',
      #   formality: nil,
      #   max_translation_length_ratio: nil,
      #   translation_length_intensity: nil
      #   use_existing_translations: false
      # }

      def initialize(template_file_path:, engine:, translation_settings:)
        @template_file_path = template_file_path
        @engine = engine
        @translation_settings = translation_settings
      end

      def call
        return unless file_exist?(source_file_path)

        source_blocks = extract_data(source_file_path)
        target_blocks = extract_data(target_file_path) if file_exist?(target_file_path)

        apply_existing_translations(source_blocks, target_blocks) if use_existing_translations && target_blocks.present?

        translate_blocks = source_blocks.reject { |block| block[:translation].present? }

        index = 0
        translate_blocks.each_slice(CHUNK_SIZE) do |blocks|
          print "\033[37m --> Processing #{blocks.size} blocks over #{translate_blocks.size}  .. \n"

          result = AiLocalizer::Services::TranslateChunkService.call(
            blocks:,
            from_lang:,
            to_lang:,
            engine:,
            formality:,
            translation_length_intensity:,
            max_translation_length_ratio:
          )

          blocks.each do |block|
            signature = block[:signature]
            block[:translation] = result[:translations][signature]
          end

          index += 1
          print "\033[37m --> Total blocks completed: #{index * CHUNK_SIZE}  .. \n\n"
        end

        AiLocalizer::Services::CreateTranslationFileService.new(
          source_file_path:,
          target_file_path:,
          blocks: source_blocks,
          from_lang: from_lang,
          to_lang: to_lang
        ).call
      end

      private

      def file_exist?(file_path)
        File.exist?(file_path)
      end

      def file_name_pattern
        @file_name_pattern ||= AiLocalizer::Utils::FileNamePattern.new(
          template_file_path:,
          from_lang:,
          to_lang:
        )
      end

      def source_file_path
        @source_file_path ||= file_name_pattern.source_file_path
      end

      def target_file_path
        @target_file_path ||= file_name_pattern.target_file_path
      end

      def apply_existing_translations(source_blocks, target_blocks)
        AiLocalizer::Utils::ImportExistingTranslation.new(source_blocks:, target_blocks:).call
      end

      def extract_data(file_path)
        AiLocalizer::Utils::YmlParser.new(file_path).call
      end

      def from_lang
        @from_lang ||= translation_settings.fetch(:from_lang)
      end

      def to_lang
        @to_lang ||= translation_settings.fetch(:to_lang)
      end

      def use_existing_translations
        @use_existing_translations ||= translation_settings[:use_existing_translations]
      end

      def formality
        @formality ||= translation_settings[:formality]
      end

      def max_translation_length_ratio
        @max_translation_length_ratio ||= translation_settings[:max_translation_length_ratio]
      end

      def translation_length_intensity
        @translation_length_intensity ||= translation_settings[:translation_length_intensity]
      end
    end
  end
end
