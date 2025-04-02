# frozen_string_literal: true

module AiLocalizer
  module Services
    class FileTranslatorService
      CHUNK_SIZE = 100

      attr_reader :template_file_path, :from_lang, :to_lang, :engine, :indicator, :use_existing_translations

      def initialize(template_file_path:, from_lang:, to_lang:, engine:, indicator: nil, use_existing_translations: true)
        @template_file_path = template_file_path
        @from_lang = from_lang
        @to_lang = to_lang
        @engine = engine
        @indicator = indicator
        @use_existing_translations = use_existing_translations
      end

      def call
        file_name_pattern = AiLocalizer::Utils::FileNamePattern.new(
          template_file_path:,
          from_lang:,
          to_lang:
        )

        return unless File.file?(file_name_pattern.source_file_path)

        source_file_path = file_name_pattern.source_file_path
        target_file_path = file_name_pattern.target_file_path

        source_blocks = extract_data(source_file_path)
        target_blocks = extract_data(target_file_path)

        apply_existing_translations(source_blocks, target_blocks) if use_existing_translations && File.file?(target_file_path)

        translate_blocks = source_blocks.reject { |block| block[:translation].present? }

        translate_blocks.each_slice(CHUNK_SIZE) do |blocks|
          result = AiLocalizer::Services::TranslateChunkService.call(blocks:, from_lang:, to_lang:, engine:)

          blocks.each do |block|
            signature = block[:signature]
            block[:translation] = result[:translations][signature]
          end
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

      def apply_existing_translations(source_blocks, target_blocks)
        AiLocalizer::Utils::ImportExistingTranslation.new(source_blocks:, target_blocks:).call
      end

      def extract_data(file_path)
        AiLocalizer::Utils::YmlParser.new(file_path).call
      end
    end
  end
end
