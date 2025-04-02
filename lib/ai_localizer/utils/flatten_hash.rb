# frozen_string_literal: true

module AiLocalizer
  module Utils
    class FlattenHash
      attr_reader :object

      def initialize(object)
        @object = object
      end

      def call
        return flatten_array_of_hashes(object.map { |entry| flatten(entry) }) if object.is_a?(Array)

        flatten(object)
      end

      private

      def flatten_array_of_hashes(hash_array)
        hash_array.each_with_object({}).with_index do |(entry, memo), index|
          entry.each { |key, value| memo[[index] + key] = value }
        end
      end

      def flatten(hash, parent_keys = [])
        hash.each_with_object({}) do |(key, value), memo|
          full_key = parent_keys + [key]

          case value
          when Hash
            memo.merge!(flatten(value, full_key))
          when Array
            value.each_with_index { |value, index| memo[full_key + [index]] = value }
          else
            memo[full_key] = value
          end
        end
      end
    end
  end
end
