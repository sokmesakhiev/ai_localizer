# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Engines::Anthropic::Engine do
  describe '.process' do
    it 'translate with Anthropic engine' do
      engine = described_class.new(from_lang: 'en', to_lang: 'es')

      translation = engine.process(
        text: ['Hello %p#12345678', 'Please type "Yes"']
      )

      expect(translation).to eq(['Hola %p#12345678', 'Por favor, escriba "Sí"'])
      expect(engine.service_name).to eq('AnthropicAPI')
    end
  end
end
