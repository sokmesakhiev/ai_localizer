# frozen_string_literal: true

require 'ai_localizer/Processors/placeholders/pre'

module AiLocalizer
  module Processors
    class Pre
      LIST = {
        placeholder_processing: AiLocalizer::Processors::Placeholders::Pre
      }.freeze

      def process_all(source:, signature:, additional_data:)
        result = source

        enabled_processors.keys.each do |key|
          break if additional_data.failed?(id: signature).present? && additional_data[signature][:failed]

          result = execute_processor(enabled_processors[key].new, result, signature, additional_data)

          additional_data.set_processed_source(id: signature, value: result.dup)
        end

        result
      end

      def execute_processor(processor, current_result, signature, additional_data)
        all_params = { source: current_result, signature:, additional_data: }
        filtered_params = all_params.select { |k, _| processor.method(:process).parameters.map(&:last).include?(k) }
        # rubocop:enable Metrics/ParameterLists
        processor.process(**filtered_params)
      end

      def enabled_processors
        LIST
      end
    end
  end
end
