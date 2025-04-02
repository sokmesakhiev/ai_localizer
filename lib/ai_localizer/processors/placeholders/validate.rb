# frozen_string_literal: true

module AiLocalizer
  module Processors
    module Placeholders
      class Validate
        def process(source:, translation:, signature:, additional_data:)
          engine = additional_data.engine

          # Here we need source which was processed with html placeholders
          processed_source = additional_data.processed_source(id: signature) || source

          extra_placholders, missing_placeholders = AiLocalizer::Utils::PlaceholderProcessor.analyze_placeholder_discrepancies(
            source: processed_source,
            translation:,
            all_placeholder_formats: additional_data.placeholder_formats,
            engine:
          )

          return translation if extra_placholders.empty? && missing_placeholders.empty?

          additional_data.set_failed(id: signature)

          source
        end
      end
    end
  end
end
