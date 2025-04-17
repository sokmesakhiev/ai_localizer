# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Utils::PromptBuilder do
  describe 'build_prompt' do
    it 'returns system and user prompts' do
      prompt_builder = described_class.new(
        from_lang: 'en',
        to_lang: 'es'
      )

      result = prompt_builder.build_prompt(content: 'Some Content')

      expect(result[:system_prompt]).to eq(<<~PROMPT.chomp)
          You are a professional translator. Ensure all translations follow the standard grammar, vocabulary, and capitalization rules for Spanish.
      PROMPT

      expect(result[:user_prompt]).to eq(<<~PROMPT.chomp)
          Translate the following content from English to Spanish. Ensure the translations are accurate, context-aware, and appropriate for use in an application, with particular attention to any technical or domain-specific terminology.

          Input Format:
          - You will receive an array of text objects in JSON format, like this:
            [{"id": "123", "text": "Here will be text “1” to be translated"}, {"id": "456", "text": "Here will be text 2 to be translated"}].

          Guidelines:
          - Maintain a neutral level of formality, ensuring consistency across all texts without mixing formal and informal styles.
          - All texts originate from the same screen or page, so use contextual cues across entries to ensure consistent and coherent translations.
          - Each translation must **preserve the original meaning and tone**, while being natural and idiomatic in the target language.


          Output Format:
          - Respond with a single JSON object mapping each "id" to its translated string.
          - The output must strictly follow this structure:
            {"123": "Translated text 1", "456": "Translated text 2"}
          - **Do not include any additional text, explanations, or formatting outside this JSON object.**

          Content to Translate: Some Content
      PROMPT
    end

    context 'soft intensity' do
      it 'renders a complete prompt with all parts' do
        prompt_builder = described_class.new(
          from_lang: 'en',
          to_lang: 'es',
          formality: 'more',
          max_translation_length_ratio: 1.2,
          translation_length_intensity: 'soft'
        )

        result = prompt_builder.build_prompt(content: '[{"id": "1", "text": "Sample text"}]')

        expect(result[:system_prompt]).to eq(<<~PROMPT.chomp)
            You are a professional translator. Ensure all translations follow the standard grammar, vocabulary, and capitalization rules for Spanish.
        PROMPT

        expect(result[:user_prompt]).to eq(<<~PROMPT.chomp)
            Translate the following content from English to Spanish. Ensure the translations are accurate, context-aware, and appropriate for use in an application, with particular attention to any technical or domain-specific terminology.

            Input Format:
            - You will receive an array of text objects in JSON format, like this:
              [{"id": "123", "text": "Here will be text “1” to be translated"}, {"id": "456", "text": "Here will be text 2 to be translated"}].

            Guidelines:
            - Maintain a neutral level of formality, ensuring consistency across all texts without mixing formal and informal styles.
            - All texts originate from the same screen or page, so use contextual cues across entries to ensure consistent and coherent translations.
            - Each translation must **preserve the original meaning and tone**, while being natural and idiomatic in the target language.
            - The total length of the translations must be equal to or less than 20.0% of the original text length, while still sounding natural and complete.

            Output Format:
            - Respond with a single JSON object mapping each "id" to its translated string.
            - The output must strictly follow this structure:
              {"123": "Translated text 1", "456": "Translated text 2"}
            - **Do not include any additional text, explanations, or formatting outside this JSON object.**

            Content to Translate: [{"id": "1", "text": "Sample text"}]
        PROMPT
      end
    end

    context 'hard intensity' do
      it 'renders a complete prompt with all parts' do
        prompt_builder = described_class.new(
          from_lang: 'en',
          to_lang: 'es',
          formality: 'more',
          max_translation_length_ratio: 1.2,
          translation_length_intensity: 'strict'
        )

        result = prompt_builder.build_prompt(content: '[{"id": "1", "text": "Sample text"}]')

        expect(result[:system_prompt]).to eq(<<~PROMPT.chomp)
            You are a professional translator. Ensure all translations follow the standard grammar, vocabulary, and capitalization rules for Spanish.
        PROMPT

        expect(result[:user_prompt]).to eq(<<~PROMPT.chomp)
            Translate the following content from English to Spanish. Ensure the translations are accurate, context-aware, and appropriate for use in an application, with particular attention to any technical or domain-specific terminology.

            Input Format:
            - You will receive an array of text objects in JSON format, like this:
              [{"id": "123", "text": "Here will be text “1” to be translated"}, {"id": "456", "text": "Here will be text 2 to be translated"}].

            Guidelines:
            - Maintain a neutral level of formality, ensuring consistency across all texts without mixing formal and informal styles.
            - All texts originate from the same screen or page, so use contextual cues across entries to ensure consistent and coherent translations.
            - Each translation must **preserve the original meaning and tone**, while being natural and idiomatic in the target language.
            - The total length of the translations must not exceed 20.0% of the original text length, even if this results in minor compromises in fluency.

            Output Format:
            - Respond with a single JSON object mapping each "id" to its translated string.
            - The output must strictly follow this structure:
              {"123": "Translated text 1", "456": "Translated text 2"}
            - **Do not include any additional text, explanations, or formatting outside this JSON object.**

            Content to Translate: [{"id": "1", "text": "Sample text"}]
        PROMPT
      end
    end
  end

  describe 'formality handling' do
    it 'builds prompt with formality message' do
      prompt_builder = described_class.new(
        from_lang: 'en',
        to_lang: 'es',
        formality: 'formal'
      )

      result = prompt_builder.build_prompt(content: '[{"id": "1", "text": "Sample text"}]')

      expect(result[:system_prompt]).to eq(<<~PROMPT.chomp)
          You are a professional translator. Ensure all translations follow the standard grammar, vocabulary, and capitalization rules for Spanish.
      PROMPT

      expect(result[:user_prompt]).to eq(<<~PROMPT.chomp)
          Translate the following content from English to Spanish. Ensure the translations are accurate, context-aware, and appropriate for use in an application, with particular attention to any technical or domain-specific terminology.

          Input Format:
          - You will receive an array of text objects in JSON format, like this:
            [{"id": "123", "text": "Here will be text “1” to be translated"}, {"id": "456", "text": "Here will be text 2 to be translated"}].

          Guidelines:
          - Use very formal language, as used by highly educated speakers in official settings.
          - All texts originate from the same screen or page, so use contextual cues across entries to ensure consistent and coherent translations.
          - Each translation must **preserve the original meaning and tone**, while being natural and idiomatic in the target language.


          Output Format:
          - Respond with a single JSON object mapping each "id" to its translated string.
          - The output must strictly follow this structure:
            {"123": "Translated text 1", "456": "Translated text 2"}
          - **Do not include any additional text, explanations, or formatting outside this JSON object.**

          Content to Translate: [{"id": "1", "text": "Sample text"}]
      PROMPT
    end

    it 'builds prompt with informality message' do
      prompt_builder = described_class.new(
        from_lang: 'en',
        to_lang: 'es',
        formality: 'informal'
      )

      result = prompt_builder.build_prompt(content: '[{"id": "1", "text": "Sample text"}]')

      expect(result[:system_prompt]).to eq(<<~PROMPT.chomp)
          You are a professional translator. Ensure all translations follow the standard grammar, vocabulary, and capitalization rules for Spanish.
      PROMPT

      expect(result[:user_prompt]).to eq(<<~PROMPT.chomp)
          Translate the following content from English to Spanish. Ensure the translations are accurate, context-aware, and appropriate for use in an application, with particular attention to any technical or domain-specific terminology.

          Input Format:
          - You will receive an array of text objects in JSON format, like this:
            [{"id": "123", "text": "Here will be text “1” to be translated"}, {"id": "456", "text": "Here will be text 2 to be translated"}].

          Guidelines:
          - Use very casual and friendly language, as used in informal conversations among close friends.
          - All texts originate from the same screen or page, so use contextual cues across entries to ensure consistent and coherent translations.
          - Each translation must **preserve the original meaning and tone**, while being natural and idiomatic in the target language.


          Output Format:
          - Respond with a single JSON object mapping each "id" to its translated string.
          - The output must strictly follow this structure:
            {"123": "Translated text 1", "456": "Translated text 2"}
          - **Do not include any additional text, explanations, or formatting outside this JSON object.**

          Content to Translate: [{"id": "1", "text": "Sample text"}]
      PROMPT
    end
  end
end
