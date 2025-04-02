# frozen_string_literal: true

module AiLocalizer
  module Engines
    module OpenAi
      class Response < AiLocalizer::Engines::BaseResponse
        private

        def sanitized_content
          @sanitized_content ||= ai_response['choices'][0]['message']['content'].strip.sub('```json', '').sub(/```$/, '')
        end
      end
    end
  end
end
