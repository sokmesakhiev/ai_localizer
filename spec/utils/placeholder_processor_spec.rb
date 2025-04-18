# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Utils::PlaceholderProcessor do
  describe '#replace_placeholders_with_original' do
    it 'replaces placeholders with their original values' do
      placeholder_map = {
        '%{name}' => '%p#01683305'
      }
      translations = ['Hello %p#01683305']

      expect(described_class.replace_placeholders_with_original(translations, placeholder_map)).to eq(['Hello %{name}'])
    end
  end

  describe '#replace_placeholders_with_original' do
    it 'replaces placeholders with their original values' do
      content = 'Hello %{name}! Welcome to the AI translator.'
      matched_placeholders = [
        { token: '%p#01683305', placeholder: '%{name}', start: 6 }
      ]
      signature = '4b922c0b173c9de4a63ad9abb8f8d80f'

      expect(described_class.replace_text_with_placeholders(content, matched_placeholders, signature)).to eq(
        'Hello %p#01683305! Welcome to the AI translator.'
      )
    end
  end

  describe '#analyze_placeholder_discrepancies' do
    context 'when there are no placeholders missing or extra' do
      it 'analyzes placeholder discrepancies' do
        source = 'Hello %{name}! Welcome to the AI translator.'
        translation = 'Hello %{name}! Welcome to the AI translator.'
        all_placeholder_formats = AiLocalizer::Entities::Placeholders::DEFAULT_PLACEHOLDERS

        extra_placeholders, missing_placeholders = described_class.analyze_placeholder_discrepancies(
          source:, translation:,
          all_placeholder_formats:
        )

        expect(extra_placeholders).to eq([])
        expect(missing_placeholders).to eq([])
      end
    end

    context 'when there are placeholders missing or extra' do
      it 'analyzes placeholder discrepancies' do
        source = 'Hello %{name}! Welcome to the AI translator.'
        translation = 'Hello %{year}! Welcome to the AI translator.'
        all_placeholder_formats = AiLocalizer::Entities::Placeholders::DEFAULT_PLACEHOLDERS

        extra_placeholders, missing_placeholders = described_class.analyze_placeholder_discrepancies(
          source:,
          translation:,
          all_placeholder_formats:
        )

        expect(extra_placeholders).to eq(['%{year}'])
        expect(missing_placeholders).to eq(['%{name}'])
      end
    end
  end
end
