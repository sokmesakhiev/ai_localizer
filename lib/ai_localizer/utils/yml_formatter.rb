# frozen_string_literal: true

module AiLocalizer
  module Utils
    class YmlFormatter
      attr_reader :from_lang, :to_lang, :source_file_path, :translations

      def initialize(source_file_path:, translations:, from_lang: nil, to_lang: nil)
        @translations = translations.index_by { |t| normalize_keys(t['index']) }
        @from_lang = from_lang
        @to_lang = to_lang
        @source_file_path = source_file_path
      end

      def call
        translation_content = format_yaml(build_translated_yml(translations))
        significant_change?(content, translation_content) ? translation_content : content
      end

      protected

      def significant_change?(old_content, new_content)
        parse_yaml(old_content) != parse_yaml(new_content)
      end

      def parse_yaml(content)
        Psych.safe_load(content, symbolize_names: true, aliases: true, permitted_classes: [Object])
      end

      def format_yaml(translated_yaml_str)
        translated_lines = translated_yaml_str.split("\n").drop(1)
        integrate_translations_into_source(translated_lines).join("\n")
      end

      def integrate_translations_into_source(translated_lines)
        result_lines = []
        line_index = 0
        translation_index = 0

        while line_index < lines.length
          current_line = lines[line_index] || ''

          # skip comment lines
          if current_line.strip.start_with?('#') || current_line.strip.empty?
            result_lines << current_line
            translated.shift if translated_lines[0].blank? && current_line.strip.blank?
          else
            result_lines << process_line(current_line.strip, translated_lines, translation_index)
            translation_index += 1 if translations.values[translation_index]
          end

          # move to next line
          line_index += 1
        end

        result_lines
      end

      def process_line(line, translated_lines, index)
        translated_line = translated_lines.shift || ''
        key = extract_key(translated_line)

        return build_inline_translated_array(translated_line, translated_lines) if inline_array?(line)
        return translated_line unless key

        process_multiline_translation(line, key)
        array_options = process_inline_array(line, key)

        translated_line += " [#{build_array_translation(translated_lines, array_options)}]" if array_options.any?
        translation_str = replace_root_locale_key(index, key, translated_line)
        apply_original_quotation_style(translation_str, index)
      end

      def inline_array?(line)
        line =~ /^(\s*)(\w+):(\s*)\[(.*)\]/
      end

      def build_inline_translated_array(key, translated)
        index = 0
        values = []
        translated.each do |t|
          if t.strip.start_with?("#{index}: ")
            values[index] = t.strip.delete("#{index}: ")
            index += 1
          else
            index.times { translated.shift } if index > 0
            break
          end
        end

        sanitized_values = values.map do |value|
          "'#{value}'"
        end

        "#{key} [#{sanitized_values.join(', ')}]"
      end

      def process_multiline_translation(line, key)
        value = extract_value(line)
        return unless value.include?('\\n')

        replace_line_with_multiline(key, value)
      end

      def replace_line_with_multiline(key, value)
        lines[index] = "#{key} : |-"
        value.gsub!(/^"|"$/, '') # Remove surrounding quotes
        value.split('\\n').each_with_index { |l, i| lines.insert(i + index + 1, l) }
      end

      def process_inline_array(line, key)
        value = extract_value(line)
        return [] unless value.strip.start_with?('[')

        lines[index] = "#{key} : |-"
        extract_array_values(value)
      end

      def extract_array_values(value)
        data = value.strip[1..-2]
        case data.strip[0]
        when '"' then scan_in_double_quote(data)
        when "'" then scan_in_single_quote(data)
        else data.split(',')
        end
      end

      def build_array_translation(translated, options)
        values = translated.shift(options.size)
        quote = options.first&.match?(/^["']/) ? options.first[0] : ''
        values.map { |v| "#{quote}#{v.strip.delete('- ')}#{quote}" }.join(', ')
      end

      def apply_original_quotation_style(translated_str, translation_index)
        original_quotation_style = translations.values[translation_index]['quotation_style']
        return translated_str unless original_quotation_style

        translated_str.gsub(/: (.*)/, ": #{original_quotation_style}\\1#{original_quotation_style}")
      end

      def extract_value(line)
        key = extract_key(line)
        key ? line.strip[(key.size + 1)..] : ''
      end

      def extract_key(line)
        return unless key_value_pair?(line)

        key = line[/^["']?(.*?)["']?:/, 1]

        return nil unless registered_key?(key)

        key
      end

      def key_value_pair?(line)
        line.include?(':')
      end

      def registered_key?(key)
        translations.keys.any? { |index| index.include?(key) }
      end

      def replace_root_locale_key(tindex, key, translated_str)
        is_rails_file? && tindex.zero? && key == from_lang ? translated_str.gsub(/^#{key}/, to_lang) : translated_str
      end

      def build_translated_yml(translations)
        ordered = AiLocalizer::Utils::FlattenHash.new(parsed).call
        sorted_translations = ordered.each_key.map { |key| translations[normalize_keys(key)] }

        res = sorted_translations.each_with_object({}) do |translation, result|
          next if translation.blank?

          translation['translation'].delete!("\n") if translation['translation'].to_s.end_with?("\n")
          result.deep_merge!(unflatten_hash(translation))
        end

        sanitize_array(res)
        convert_to_yaml(res)
      end

      def convert_to_yaml(hash)
        keys = get_long_keys(hash)
        hash = replace_long_key(hash, keys) if keys.present?
        yaml = hash.to_yaml(line_width: -1)
        replace_yaml_with_old_key(yaml, keys)
      end

      def replace_long_key(hash, keys)
        hash.deep_transform_keys do |key|
          next unless key.is_a? String

          if key.size > 128
            keys.invert[key]
          else
            key
          end
        end
      end

      def get_long_keys(hash)
        keys = {}
        hash.each do |key, _value|
          next unless key.is_a? String

          if key.size > 128
            new_key = Digest::MD5.hexdigest(key)[0..15]
            keys[new_key] = key
          end

          keys.merge!(get_long_keys(hash[key])) if hash[key].is_a? Hash
        end

        keys
      end

      def replace_yaml_with_old_key(yaml, keys)
        keys.each do |key, value|
          yaml.gsub!(key, value)
        end

        yaml
      end

      def normalize_keys(keys)
        keys.map { |key| key.to_s.gsub("''", "'") }
      end

      def is_rails_file?
        @is_rails_file ||= parsed.key?(from_lang) && parsed.keys.size >= 1
      end

      def parsed
        @parsed ||= AiLocalizer::Utils::YmlParser.new(tmpfile).raw_entries
      end

      def tmpfile
        file = Tempfile.new(SecureRandom.base64(16))
        file.write(content)
        file.close
        file.path
      end

      def unflatten_hash(translation_object)
        translation_object['index'].reverse.inject(translation_object['translation']) { |val, key| { key => val } }
      end

      def sanitize_array(data)
        return data unless data.is_a?(Hash)

        if array_like?(data)
          data.keys.sort.map { |index| sanitize_array(data[index]) }
        else
          data.transform_values { |value| sanitize_array(value) }
        end
      end

      def array_like?(data)
        data.keys.all?(Integer) && data.keys.max == (data.keys.size - 1)
      end

      def scan_in_single_quote(line)
        line.scan(/'([^,]*)'/).map { |v| "'#{v[0]}'" }
      end

      def scan_in_double_quote(line)
        line.scan(/"([^,]*)"/).map { |v| "\"#{v[0]}\"" }
      end

      def content
        @content ||= File.read(source_file_path)
      end

      def lines
        @lines ||= content.split("\n")
      end
    end
  end
end
