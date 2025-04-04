# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Api::Translator do
  it "translates texts from 'en' to 'es'" do
    texts = [
      'Hello %{name}',
      '<p>AI translator</p>.',
      'All "rights" reserved. Copyright (c) %{year}.'
    ]

    result = described_class.new(texts:, from_lang: 'en', to_lang: 'es').call

    expect(result).to eq(
      [
        'Hola %{name}',
        '<p>Traductor de IA</p>.',
        'Todos los "derechos" reservados. Copyright (c) %{year}.'
      ]
    )
  end
end
