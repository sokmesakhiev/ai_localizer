# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Processors::Placeholders::Post do
  describe '#process' do
    let(:translation) { 'Hello %p#12345678' }
    let(:placeholder_backward_map) { { '%{name}' => '%p#12345678' } }
    let(:additional_data) { instance_double(AiLocalizer::Entities::TranslationConfiguration, placeholder_backward_map:) }

    it 'replaces token with placeholder' do
      result = described_class.new.process(translation:, additional_data:)

      expect(result).to eq('Hello %{name}')
    end
  end
end
