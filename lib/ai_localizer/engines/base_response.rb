# frozen_string_literal: true

module AiLocalizer
  module Engines
    class BaseResponse
      attr_reader :ai_response, :text

      def initialize(ai_response:, text:)
        @ai_response = ai_response
        @text = text
      end

      def call
        AiLocalizer::Utils::Recovery.new(str: sanitized_content, text:).call
      end

      private

      def sanitized_content
        ''
      end
    end
  end
end
