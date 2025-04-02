# frozen_string_literal: true

module AiLocalizer
  module Engines
    module Bedrock
      class Response < AiLocalizer::Engines::BaseResponse
        private

        def sanitized_content
          @sanitized_content ||= ai_response['content'].first['text'].strip.sub('```json', '').sub(/```$/, '')
        end
      end
    end
  end
end
