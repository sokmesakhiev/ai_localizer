# frozen_string_literal: true

module AiLocalizer
  module Utils
    class FileNamePattern
      attr_reader :template_file_path, :from_lang, :to_lang

      def initialize(template_file_path:, from_lang:, to_lang:)
        @template_file_path = template_file_path
        @from_lang = from_lang
        @to_lang = to_lang
      end

      def source_file_path
        template_file_path.gsub('{{lang}}', from_lang)
      end

      def target_file_path
        template_file_path.gsub('{{lang}}', to_lang)
      end
    end
  end
end
