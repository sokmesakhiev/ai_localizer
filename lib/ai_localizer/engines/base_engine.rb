# frozen_string_literal: true

module AiLocalizer
  module Engines
    class BaseEngine
      CONTEXT_WINDOW = 200_000               # LLM's full token capacity (input + output)
      MAX_OUTPUT_TOKENS = 8_000              # Max tokens in LLM's response
      TRANSLATION_TO_SOURCE_LENGTH_RATIO = 1.5
      IDEAL_BATCH_SIZE = (MAX_OUTPUT_TOKENS / TRANSLATION_TO_SOURCE_LENGTH_RATIO).to_i

      attr_reader :from_lang, :to_lang

      def initialize(from_lang:, to_lang:)
        @from_lang = from_lang
        @to_lang = to_lang
      end

      def translate(text:, formality: nil, max_translation_length_ratio: nil, translation_length_intensity: nil)
        prompt_builder = AiLocalizer::Utils::PromptBuilder.new(
          from_lang:,
          to_lang:,
          formality:,
          max_translation_length_ratio:,
          translation_length_intensity:
        )

        structured_texts = structure_texts(text)
        prompt = prompt_builder.build_prompt
        input_token_limit = calculate_available_input_tokens(prompt)

        results = {}
        pending_texts = structured_texts.dup

        while pending_texts.any?
          batches = create_batches(pending_texts, input_token_limit)

          batches.each do |batch|
            prompt = prompt_builder.build_prompt(content: Oj.dump(batch, mode: :compat))
            translated = client.translate(text: batch, **prompt)

            if translated.any?
              translated.each do |key, value|
                results[key.to_i] = value
                pending_texts.delete(key.to_i)
              end
            else
              # fallback: remove first entry to prevent infinite loop
              pending_texts.shift
            end
          end
        end

        results.sort.to_h.values
      end

      private

      def structure_texts(texts)
        texts.each_with_index.to_h do |text, idx|
          [idx, { 'id' => idx.to_s, 'text' => text }]
        end
      end

      def create_batches(items, max_tokens)
        batches = []
        current_batch = []
        current_tokens = 0

        items.each_value do |block|
          block_text = block.to_s
          tokens = token_count(block_text)

          next if tokens > max_tokens

          if (current_tokens + tokens) <= max_tokens
            current_batch << block
            current_tokens += tokens
          else
            batches << current_batch unless current_batch.empty?
            current_batch = [block]
            current_tokens = tokens
          end
        end

        batches << current_batch unless current_batch.empty?

        batches
      end

      def calculate_available_input_tokens(prompt)
        used_tokens = count_prompt_tokens(prompt)
        [IDEAL_BATCH_SIZE, CONTEXT_WINDOW - MAX_OUTPUT_TOKENS - used_tokens].min
      end

      def count_prompt_tokens(prompt)
        request_structure = [
          { 'role' => 'system', 'content' => prompt[:system_prompt] },
          { 'role' => 'user', 'content' => prompt[:user_prompt] }
        ]
        token_count(request_structure.to_json)
      end

      def token_count(text)
        OpenAI.rough_token_count(text)
      end
    end
  end
end
