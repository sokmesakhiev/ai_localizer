# frozen_string_literal: true

module AiLocalizer
  module Utils
    module PlaceholderProcessor
      def self.replace_placeholders_with_original(translations, placeholder_map)
        translations.map do |content|
          next content unless content.is_a?(String)

          placeholder_map.keys.reverse_each do |key|
            value = placeholder_map[key]
            content = content.gsub(value, key) if value
          end

          content
        end
      end

      def self.replace_text_with_placeholders(content, matched_placeholders, signature)
        return content unless content.is_a?(String) && matched_placeholders.any?

        content = content.dup
        length_adjustment = 0

        matched_placeholders.sort_by { |ph| ph[:start] }.each do |ph|
          token = ph[:token]
          start_idx = ph[:start] + length_adjustment
          content[start_idx, ph[:placeholder].length] = token
          length_adjustment += token.length - ph[:placeholder].length
        end

        content
      end

      def self.analyze_placeholder_discrepancies(source:, translation:, all_placeholder_formats:)
        source_placeholders = extract_placeholders(source, all_placeholder_formats)
        translation_placeholders = extract_placeholders(translation, all_placeholder_formats)

        source_counts = count_placeholder_occurrences(source_placeholders)
        translation_counts = count_placeholder_occurrences(translation_placeholders)

        missing_placeholders = find_missing_placeholders(source_counts, translation_counts)
        extra_placeholders = find_missing_placeholders(translation_counts, source_counts)

        [extra_placeholders, missing_placeholders]
      end

      def self.count_placeholder_occurrences(placeholders)
        placeholders.each_with_object(Hash.new(0)) { |ph, counts| counts[ph[:placeholder]] += 1 }
      end

      def self.find_missing_placeholders(source_counts, comparison_counts)
        source_counts.each_with_object([]) do |(placeholder, count), result|
          diff = count - comparison_counts.fetch(placeholder, 0)
          result.concat([placeholder] * diff) if diff.positive?
        end
      end

      def self.extract_placeholders(text, placeholder_formats)
        get_all_uniq_placeholders(text, placeholder_formats)
      end

      def self.get_all_uniq_placeholders(content, placeholder_formats)
        matches_with_indexes = []

        return matches_with_indexes if content.blank?

        placeholder_formats.each do |pattern|
          regex = Regexp.new(pattern)

          content.enum_for(:scan, regex).each do
            match = $LAST_MATCH_INFO
            start_index = match.begin(0)
            end_index = match.end(0) - 1
            matched_text = match[0]

            new_placeholder = { start: start_index, end: end_index, placeholder: matched_text, pattern:}

            type = case pattern
                   when AiLocalizer::Entities::Placeholders::OPEN_TAG
                     'open_html_tag'
                   when AiLocalizer::Entities::Placeholders::CLOSE_TAG
                     'close_html_tag'
                   else
                     nil
                   end

            new_placeholder[:token] = AiLocalizer::Utils::Tokenizer.generate_token(token_root: matched_text, type:)

            matches_with_indexes << new_placeholder
          end
        end

        matches_with_indexes
      end
    end
  end
end
