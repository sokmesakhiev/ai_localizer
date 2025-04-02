# frozen_string_literal: true

module AiLocalizer
  module Processors
    module Placeholders
      class Pre
        def process(source:, signature:, additional_data:)
          return source unless source.is_a?(String)

          placeholders = AiLocalizer::Utils::PlaceholderProcessor.extract_placeholders(
            remove_token(source.dup),
            additional_data.placeholder_formats
          )

          backward_patterns = placeholders.to_h { |ph| [ph[:placeholder], ph[:token]] }

          additional_data.placeholder_backward_map.merge!(backward_patterns)

          apply_placeholders(placeholders, source, signature)
        end

        private

        def remove_token(string)
          return string unless string.is_a?(String)

          source = string.dup

          AiLocalizer::Utils::Tokenizer::PRESERVE_TOKENS.each do |token|
            regex = Regexp.new(token)
            string.enum_for(:scan, regex).each do
              match = $LAST_MATCH_INFO
              matched_text = match[0]

              next if matched_text.blank?

              source.gsub!(matched_text, 'X' * matched_text.size)
            end
          end

          source
        end

        def apply_placeholders(placeholders, string, signature)
          AiLocalizer::Utils::PlaceholderProcessor.replace_text_with_placeholders(string.dup, placeholders, signature)
        end
      end
    end
  end
end
