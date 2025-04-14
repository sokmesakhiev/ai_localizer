# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Engines::Gemini::Engine do
  describe '.process' do
    it 'translate with Deepseek engine' do
      # engine = described_class.new(from_lang: 'en', to_lang: 'es')
      #
      # translation = engine.translate(
      #   text: ['Hello %p#12345678', 'Welcome to "China"']
      # )

      expect(ENV["ANTHROPIC_API_KEY"]).to eq("123")
    end
  end
end
