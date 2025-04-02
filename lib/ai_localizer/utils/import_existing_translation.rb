# frozen_string_literal: true

module AiLocalizer
  module Utils
    class ImportExistingTranslation
      attr_reader :source_blocks, :target_blocks

      def initialize(source_blocks:, target_blocks:)
        @source_blocks = source_blocks
        @target_blocks = target_blocks
      end

      def call
        source_blocks.each do |source_block|
          target_block = target_blocks.find { |target_block| target_block[:index][1..] == source_block[:index][1..] }

          source_block[:translation] = target_block[:original] if target_block.present?
        end
      end
    end
  end
end
