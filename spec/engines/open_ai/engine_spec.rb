# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Engines::OpenAi::Engine do
  describe '.process' do
    it 'translate with OpenAI engine' do
      engine = described_class.new(from_lang: 'en', to_lang: 'es')

      translation = engine.process(text: ['Hello %p#12345678', 'How are you?'])

      expect(translation).to eq(['Hola %p#12345678', '¿Cómo estás?'])
      expect(engine.service_name).to eq('OpenAI')
    end
  end
end
