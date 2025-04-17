# frozen_string_literal: true

module AiLocalizer
  module Engines
    module Gemini
      class Response < AiLocalizer::Engines::BaseResponse
        private

        def sanitized_content
          @sanitized_content ||= body_parts.reduce({}) { |acc, h| acc.merge(JSON.parse(h)) }.to_json
        end

        def body_parts
          @body_parts ||= JSON.parse(ai_response.body)["candidates"][0]["content"]["parts"].map { |part| part["text"].strip.sub('```json', '').sub(/```$/, '') }
        end
      end
    end
  end
end
