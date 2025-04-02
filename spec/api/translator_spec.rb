# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Api::Translator do
  it "translates texts from 'en' to 'es'" do
    texts = [
      'Hello %{name}',
      '<p>AI translator</p>. Please read "about" page to learn more about this project.',
      'All rights reserved. Copyright (c) %{year}.'
    ]

    result = described_class.new(texts:, from_lang: 'en', to_lang: 'es').call

    expect(result).to eq(
      [
        'Hola %{name}',
        '<p>Traductor de IA</p>. Por favor, lea la página "acerca de" para obtener más información sobre este proyecto.',
        'Todos los derechos reservados. Copyright (c) %{year}.'
      ]
    )
  end
end
