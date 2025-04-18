# frozen_string_literal: true

module AiLocalizer
  module Engines
    module Deepseek
      class Response < AiLocalizer::Engines::BaseResponse
        private

        def sanitized_content
          @sanitized_content ||= body_content.sub('```json', '').sub(/```$/, '')
        end

        def body_content
          @body_content ||= ai_response['choices'][0]['message']['content'].strip
        end
      end
    end
  end
end
