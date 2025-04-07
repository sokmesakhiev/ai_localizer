# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Utils::YmlFormatter do
  let(:source_file_path) { 'spec/fixtures/en.yml' }
  let(:source_yml) { File.read(source_file_path) }
  let(:translations) do
    [
      { 'index' => %w[en title welcome], 'translation' => 'Hola %{name}' },
      { 'index' => %w[en title header], 'translation' => 'Traductor de IA' },
      { 'index' => %w[en body description], 'translation' => '<p>Traductor de IA</p>.' },
      { 'index' => %w[en body author], 'translation' => 'Sokmesakhiev' },
      { 'index' => ['en', 'body', 'options', 0], 'translation' => 'Opción 1' },
      { 'index' => ['en', 'body', 'options', 1], 'translation' => 'Opción 2' },
      { 'index' => ['en', 'body', 'choices', 0], 'translation' => 'Hola' },
      { 'index' => ['en', 'body', 'choices', 1], 'translation' => 'Mundo' },
      { 'index' => %w[en footer copyright], 'translation' => 'Todos los "derechos" reservados. Copyright (c) %{year}.' }
    ]
  end
  let(:translated_yml) { File.read('spec/fixtures/es.yml') }

  it 'formats a YML file' do
    dir_path = 'spec/fixtures/'

    translated = described_class.new(source_file_path:, translations:, from_lang: 'en', to_lang: 'es').call

    expect(translated).to eq(translated_yml)
  end
end
