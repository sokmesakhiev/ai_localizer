# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Services::FileTranslatorService do
  let(:target_file_path) { 'spec/fixtures/es.yml' }
  let(:template_file_path) { 'spec/fixtures/{{lang}}.yml' }
  let(:translated_yml) { File.read(target_file_path) }
  let(:engine) { AiLocalizer::Engines::Bedrock::Engine.new(from_lang: 'en', to_lang: 'es') }
  let(:translation_settings) do
    {
      from_lang: 'en',
      to_lang: 'es',
      formality: nil,
      max_translation_length_ratio: nil,
      translation_length_intensity: nil
    }
  end

  context 'without import existing translation' do
    it 'parses a valid YML file' do
      expected_yml = "es:
  title:
    welcome: Hola %{name}
    header: Traductor de IA
  # Body content
  body:
    description: \"<p>Traductor de IA</p>.\"
    # Author name
    author: Sokmesakhiev
    options:
      0: Opción 1
      1: Opción 2
    choices: ['Hola', 'Mundo']
  # Footer content
  footer:
    copyright: Todos los \"derechos\" reservados. Copyright (c) %{year}."

      translation_settings[:use_existing_translations] = false

      described_class.new(template_file_path:, engine:, translation_settings:).call

      expect(File).to exist(target_file_path)
      expect(translated_yml).to eq(expected_yml)
    end

    context 'with import existing translation' do
      it 'does not overwrite existing translation' do
        allow(described_class).to receive(:call)
        translation_settings[:use_existing_translations] = true

        described_class.new(template_file_path:, engine:, translation_settings:).call

        expect(described_class).not_to have_received(:call)
      end
    end
  end
end
