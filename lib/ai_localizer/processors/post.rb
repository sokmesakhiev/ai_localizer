# frozen_string_literal: true

require 'ai_localizer/processors/placeholders/post'
require 'ai_localizer/processors/placeholders/validate'

module AiLocalizer
  module Processors
    class Post
      LIST = {
        placeholder_processing: AiLocalizer::Processors::Placeholders::Post,
        force_all_placeholders: AiLocalizer::Processors::Placeholders::Validate
      }.freeze

      def process_all(source:, translation:, signature:, additional_data:)
        result = translation

        enabled_processors.keys.each do |key|
          break if additional_data.failed?(id: signature).present? && additional_data[signature][:failed]

          result = execute_processor(enabled_processors[key].new, source, result, signature, additional_data)

          additional_data.set_processed_source(id: signature, value: result.dup)
        end

        result
      end

      def execute_processor(processor, source, current_result, signature, additional_data)
        all_params = { source:, translation: current_result, additional_data:, signature: }
        filtered_params = all_params.select { |k, _v| processor.method(:process).parameters.map(&:last).include?(k) }
        processor.process(**filtered_params)
      end

      def enabled_processors
        LIST
      end
    end
  end
end
