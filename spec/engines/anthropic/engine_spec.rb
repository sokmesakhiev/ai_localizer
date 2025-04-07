# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Engines::Anthropic::Engine do
  describe '.process' do
    it 'translate with Anthropic engine' do
      engine = described_class.new(from_lang: 'en', to_lang: 'es')

      translation = engine.process(
        text: ['Hello %p#12345678', 'Welcome to "Cambodia"']
      )

      expect(translation).to eq(['Hola %p#12345678', 'Bienvenido a "Camboya"'])
    end
  end
end
