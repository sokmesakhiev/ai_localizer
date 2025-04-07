# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Utils::YmlParser do
  it 'parses a valid YML file' do
    result = described_class.new('spec/fixtures/en.yml').call

    expect(result).to eq(
      [
        {
          existing_translation: nil,
          index: %w[en title welcome],
          original: 'Hello %{name}',
          path: 'spec/fixtures/en.yml',
          signature: '54bffaa8804a300829f22de6495e1db7'
        },
        {
          existing_translation: nil,
          index: %w[en title header],
          original: 'AI translator',
          path: 'spec/fixtures/en.yml',
          signature: '3df4a151dd994baf489f5bd4f543a1ff'
        },
        {
          existing_translation: nil,
          index: %w[en body description],
          original: '<p>AI translator</p>.',
          path: 'spec/fixtures/en.yml',
          signature: '81e06b692e478f376971717e2258143e'
        },
        {
          existing_translation: nil,
          index: %w[en body author],
          original: 'Sokmesakhiev',
          path: 'spec/fixtures/en.yml',
          signature: 'dcfc310e86da4afd6f4cba16e33cbf65'
        },
        {
          existing_translation: nil,
          index: ['en', 'body', 'options', 0],
          original: 'Option 1',
          path: 'spec/fixtures/en.yml',
          signature: '15f286f408ffd73836f46a95e1349553'
        },
        {
          existing_translation: nil,
          index: ['en', 'body', 'options', 1],
          original: 'Option 2',
          path: 'spec/fixtures/en.yml',
          signature: 'dabfeae8bf555178cd6c87810de13301'
        },
        {
          existing_translation: nil,
          index: ['en', 'body', 'choices', 0],
          original: 'Hello',
          path: 'spec/fixtures/en.yml',
          signature: '7bbf2c65330a5a237b28c8954aa0ba66'
        },
        {
          existing_translation: nil,
          index: ['en', 'body', 'choices', 1],
          original: 'World',
          path: 'spec/fixtures/en.yml',
          signature: '8a5341685c32f835da3987447c930f16'
        },
        {
          existing_translation: nil,
          index: %w[en footer copyright],
          original: 'All "rights" reserved. Copyright (c) %{year}.',
          path: 'spec/fixtures/en.yml',
          signature: '277bf3a3664a8dacf6d5310e5e04e733'
        }
      ]
    )
  end
end
