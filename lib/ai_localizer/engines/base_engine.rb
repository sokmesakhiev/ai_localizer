# frozen_string_literal: true

module AiLocalizer
  module Engines
    class BaseEngine
      CONTEXT_WINDOW = 200_000 # LLM's working memory (input + output text)
      MAX_OUTPUT_TOKENS = 8_000 # Max tokens allowed in the LLM's response
      TRANSLATION_TO_SOURCE_LENGTH_RATIO = 1.5 # Estimated expansion factor for translation
      IDEAL_BATCH_SIZE = (MAX_OUTPUT_TOKENS / TRANSLATION_TO_SOURCE_LENGTH_RATIO).to_i # ideal size (in tokens) of one batch of original text in one request to the LLM

      attr_reader :from_lang, :to_lang, :formality, :max_translation_length_ratio

      def initialize(from_lang:, to_lang:, formality: nil, max_translation_length_ratio: nil)
        @from_lang = from_lang
        @to_lang = to_lang
        @formality = formality
        @max_translation_length_ratio = max_translation_length_ratio
      end

      def translate(text:)
        aggregated_translations = []
        prompt_builder = AiLocalizer::Utils::PromptBuilder.new(from_lang:, to_lang:, formality:, max_translation_length_ratio:)
        remaining_texts = create_structured_texts(text)

        minimal_prompt = prompt_builder.render
        max_input_size = free_space_size(minimal_prompt)

        batches = create_batches(remaining_texts, max_input_size)

        loop do
          break if batches.empty?

          batches.each do |batch|
            prompt = prompt_builder.render(content: Oj.dump(batch, mode: :compat))
            translated_items = client.translate(text: batch, **prompt)

            if translated_items.any?
              translated_items.each do |key, value|
                aggregated_translations[key.to_i] = value
                remaining_texts.delete(key.to_i)
              end
            else
              remaining_texts.shift
            end

            batches = create_batches(remaining_texts, max_input_size)
          end
        end

        aggregated_translations
      end

      private

      def create_structured_texts(texts)
        texts.each_with_index.each_with_object({}) do |(text, idx), result|
          result[idx] = { 'id' => idx.to_s, 'text' => text }
        end
      end

      def create_batches(blocks, max_input_size)
        batches = []
        current_batch = []
        current_batch_tokens = 0

        blocks.each_value do |block|
          text = block.to_s
          line_tokens = get_token_count_by_model(text:)

          if line_tokens > max_input_size
            next
          end

          if (current_batch_tokens + line_tokens) <= max_input_size
            current_batch << block
            current_batch_tokens += line_tokens
          else
            batches << current_batch unless current_batch.empty?
            current_batch = [block]
            current_batch_tokens = line_tokens
          end
        end

        batches << current_batch unless current_batch.empty?
        batches
      end

      def free_space_size(prompt)
        template_prompt_size = used_tokens_count(prompt)

        available_input_tokens = CONTEXT_WINDOW - MAX_OUTPUT_TOKENS - template_prompt_size

        [IDEAL_BATCH_SIZE, available_input_tokens].min
      end

      def used_tokens_count(prompt)
        request_body = [
          { 'role' => 'system', 'content' => prompt[:system_prompt] },
          { 'role' => 'user', 'content' => prompt[:user_prompt] }
        ]

        get_token_count_by_model(text: request_body.to_json)
      end

      def get_token_count_by_model(text:)
        OpenAI.rough_token_count(text)
      end
    end
  end
end
