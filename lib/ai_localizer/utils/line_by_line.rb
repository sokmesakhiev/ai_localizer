# frozen_string_literal: true

module AiLocalizer
  module Utils
    class LineByLine
      def initialize(str)
        @str = str
      end

      def call
        parsed_lines = {}
        @str.each_line do |line|
          parsed_lines.merge!(try_parsing(line.strip))
        end
        parsed_lines.empty? ? @str : parsed_lines
      end

      private

      def try_parsing(line)
        loop do
          line = line.gsub(/```json(.*)```/, '\+')
          break unless line.match?(/```json(.*)```/)
        end

        line = line.sub(/^{?/, '').sub(/}?$/, '').chomp(',')
        JSON.parse("{#{line}}")
      rescue StandardError
        {}
      end
    end
  end
end
