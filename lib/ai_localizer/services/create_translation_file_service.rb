# frozen_string_literal: true

module AiLocalizer
  module Services
    class CreateTranslationFileService < AiLocalizer::Services::Base
      attr_reader :from_lang, :to_lang, :blocks, :source_file_path, :target_file_path

      def initialize(source_file_path:, target_file_path:, blocks:, from_lang:, to_lang:)
        @blocks = blocks
        @from_lang = from_lang
        @to_lang = to_lang
        @source_file_path = source_file_path
        @target_file_path = target_file_path
      end

      def call
        translations = blocks.map do |block|
          block.slice(:index, :translation).transform_keys(&:to_s)
        end

        print "\033[37m --> Formatting #{target_file_path}  .. \n"
        content = AiLocalizer::Utils::YmlFormatter.new(
          source_file_path:,
          from_lang:,
          to_lang:,
          translations:
        ).call

        print "\033[37m --> Creating #{target_file_path}  .. \n"
        File.write(target_file_path, content)
        print "\033[37m --> File #{target_file_path} is created .. \n"

        content
      end
    end
  end
end
