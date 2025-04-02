# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Utils::FileNamePattern do
  it 'detects source_file_path and target_file_path' do
    file_name_pattern = described_class.new(
      template_file_path: 'spec/fixtures/{{lang}}.yml',
      from_lang: 'en',
      to_lang: 'es'
    )

    expect(file_name_pattern.source_file_path).to eq('spec/fixtures/en.yml')
    expect(file_name_pattern.target_file_path).to eq('spec/fixtures/es.yml')
  end
end
