# frozen_string_literal: true

module AiLocalizer
  module Utils
    class YmlParser
      PERMITTED_TYPE_CLASSES = [Time, Symbol, String, Array].freeze
      FILE_PARSER_PAYLOAD_KEYS = %i[path existing_translation original index signature].freeze

      def self.call(*args)
        new(*args).call
      end

      def initialize(file)
        @file = file
        @entries = load_entries(file)
      end

      def load_entries(file)
        yaml_content = preprocess(read_file(file))

        YAML.safe_load(yaml_content, permitted_classes: PERMITTED_TYPE_CLASSES, aliases: true)
      end

      def raw_entries
        entries
      end

      def call
        flattened_entries.flat_map do |entry|
          entry.keys.map do |key|
            generate_payload_from_entry(
              AiLocalizer::Entities::SourceBlock.decorate(key, index: key, original: entry[key], path: file)
            )
          end
        end
      end

      private

      attr_reader :entries, :file

      # Ensures YAML keys 'yes' and 'no' are treated as strings, not booleans
      def preprocess(str)
        str.gsub(/^(yes|no):/, '"\1":')
      end

      def flattened_entries
        @flattened_entries ||= [AiLocalizer::Utils::FlattenHash.new(entries).call]
      end

      def generate_payload_from_entry(entry)
        payload = {}

        FILE_PARSER_PAYLOAD_KEYS.each do |key|
          payload[key] = entry.try(key)
        end

        if entry.original.is_a?(String) && (match = entry.original.match(/: (['"])(.*)\1/))
          payload[:quotation_style] = match[1]
        end

        payload
      end

      def read_file(file)
        File.read(file)
      end
    end
  end
end
