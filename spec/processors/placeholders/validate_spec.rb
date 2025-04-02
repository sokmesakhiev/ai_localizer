# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Processors::Placeholders::Validate do
  describe '#process' do
    context 'when placeholders are valid' do
      let(:source) { 'Hello %{name}' }
      let(:translation) { 'Hola %{name}' }

      it 'leaves the translation unchanged' do
        additional_data = AiLocalizer::Entities::TranslationConfiguration.new(
          placeholder_formats: AiLocalizer::Entities::Placeholders::DEFAULT_PLACEHOLDERS,
          engine: AiLocalizer::Engines::Bedrock::Engine.new(from_lang: 'en', to_lang: 'es')
        )

        result = described_class.new.process(source:, translation:, signature: '1111', additional_data:)

        expect(result).to eq(translation)
      end
    end

    context 'when placeholders are invalid' do
      let(:source) { 'Hello %{name}' }
      let(:translation) { 'Hola %{names}' }

      it 'leaves the translation as a source' do
        additional_data = AiLocalizer::Entities::TranslationConfiguration.new(
          placeholder_formats: AiLocalizer::Entities::Placeholders::DEFAULT_PLACEHOLDERS,
          engine: AiLocalizer::Engines::Bedrock::Engine.new(from_lang: 'en', to_lang: 'es')
        )

        result = described_class.new.process(source:, translation:, signature: '1111', additional_data:)

        expect(result).to eq(source)
        expect(additional_data.failed?(id: '1111')).to be true
      end
    end

    context 'when placeholders are missing' do
      let(:source) { 'Hello %{name}' }
      let(:translation) { 'Hola' }

      it 'leaves the translation as a source' do
        additional_data = AiLocalizer::Entities::TranslationConfiguration.new(
          placeholder_formats: AiLocalizer::Entities::Placeholders::DEFAULT_PLACEHOLDERS,
          engine: AiLocalizer::Engines::Bedrock::Engine.new(from_lang: 'en', to_lang: 'es')
        )

        result = described_class.new.process(source:, translation:, signature: '1111', additional_data:)

        expect(result).to eq(source)
        expect(additional_data.failed?(id: '1111')).to be true
      end
    end

    context 'when translation has extra placeholders' do
      let(:source) { 'Hello %{name}' }
      let(:translation) { 'Hola %{name} %{name}' }

      it 'leaves the translation as a source' do
        additional_data = AiLocalizer::Entities::TranslationConfiguration.new(
          placeholder_formats: AiLocalizer::Entities::Placeholders::DEFAULT_PLACEHOLDERS,
          engine: AiLocalizer::Engines::Bedrock::Engine.new(from_lang: 'en', to_lang: 'es')
        )

        result = described_class.new.process(source:, translation:, signature: '1111', additional_data:)

        expect(result).to eq(source)
        expect(additional_data.failed?(id: '1111')).to be true
      end
    end
  end
end
