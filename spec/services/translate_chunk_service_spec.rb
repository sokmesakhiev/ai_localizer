# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Services::TranslateChunkService do
  it 'parses a valid YML file' do
    engine = AiLocalizer::Engines::Bedrock::Engine.new(from_lang: 'en', to_lang: 'es')
    blocks = [{
      context: nil,
      entry: nil,
      existing_translation: nil,
      index: %w[en welcome],
      original: 'Hello AI translator!',
      parent_index: nil,
      path: 'spec/fixtures/valid.yml',
      plural: nil,
      plural_count: nil,
      signature: '4b922c0b173c9de4a63ad9abb8f8d80f'
    }]

    result = described_class.new(blocks:, from_lang: 'en', to_lang: 'es', engine:).call

    expect(result).to eq(
      {
        translations: { '4b922c0b173c9de4a63ad9abb8f8d80f' => '¡Hola traductor de IA!' },
        not_translated: {}
      }
    )
  end
end
