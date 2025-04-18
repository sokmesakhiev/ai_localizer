# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Utils::ImportExistingTranslation do
  it 'adds existing translation to the source blocks' do
    source_blocks = [
      {
        index: %w[en title welcome],
        original: 'Hello AI translator!'
      },
      {
        index: %w[en title header],
        original: 'AI translator'
      },
      {
        index: %w[en body author],
        original: 'Sokmesakhiev'
      },
      {
        index: %w[en body description],
        original: '<p>AI translator</p>. Please read "about" page to learn more about this project.'
      }
    ]

    target_blocks = [
      {
        index: %w[es title welcome],
        original: 'Hola AI translator!'
      },
      {
        index: %w[es title header],
        original: 'Traductor de IA'
      },
      {
        index: %w[es body description],
        original: '<p>Traductor de IA</p>. Por favor, lea la página "acerca de" para obtener más información sobre este proyecto.'
      }
    ]

    described_class.new(source_blocks:, target_blocks:).call

    expect(source_blocks[0][:translation]).to eq('Hola AI translator!')
    expect(source_blocks[1][:translation]).to eq('Traductor de IA')
    expect(source_blocks[2][:translation]).to eq(nil)
    expect(source_blocks[3][:translation]).to eq('<p>Traductor de IA</p>. Por favor, lea la página "acerca de" para obtener más información sobre este proyecto.')
  end
end
