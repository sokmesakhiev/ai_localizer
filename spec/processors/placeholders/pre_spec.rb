# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Processors::Placeholders::Pre do
  describe '#process' do
    let(:source) { 'Hello %{name}' }

    it 'replaces placeholder with token' do
      additional_data = AiLocalizer::Entities::TranslationConfiguration.new(
        placeholder_formats: AiLocalizer::Entities::Placeholders::DEFAULT_PLACEHOLDERS
      )

      result = described_class.new.process(source:, signature: '1111', additional_data:)

      expect(result).to eq('Hello %p#01683305')
      expect(additional_data.placeholder_backward_map).to eq({ '%{name}' => '%p#01683305' })
    end
  end
end
