# frozen_string_literal: true

require_relative './line_by_line'

module AiLocalizer
  module Utils
    class Recovery
      STRATEGY_CONFIG = [
        {
          strategy: AiLocalizer::Utils::LineByLine,
          max_attempts: 1
        }
      ].freeze

      def initialize(str:, text: '')
        @str = str
        @text = text
      end

      def call
        valid_json = valid_json_or_nil(@str)
        return valid_json if valid_json

        config.each do |config|
          result = @str.dup
          strategy_class = config[:strategy]
          max_attempts = config[:max_attempts]

          max_attempts.times do |attempt|
            result = strategy_class.new(result).call

            return result if result.is_a?(Hash)

            valid_json = valid_json_or_nil(result)
            return valid_json if valid_json
          end
        end
        {}
      rescue JSON::ParserError => e
        {}
      end

      def config
        STRATEGY_CONFIG
      end

      def valid_json_or_nil(str)
        JSON.parse(str)
      rescue JSON::ParserError => e
        nil
      end
    end
  end
end
