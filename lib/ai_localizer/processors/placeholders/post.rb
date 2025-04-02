# frozen_string_literal: true

module AiLocalizer
  module Processors
    module Placeholders
      class Post
        def process(translation:, additional_data:)
          AiLocalizer::Utils::PlaceholderProcessor.replace_placeholders_with_original(
            [translation.dup],
            additional_data.placeholder_backward_map
          ).first
        end
      end
    end
  end
end
