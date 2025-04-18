RSpec.describe AiLocalizer do
  let(:from_lang) { 'en' }
  let(:target_langs) { %w[es fr] }
  let(:template_file_path) { 'spec/fixtures/{{lang}}.yml' }
  let(:configuration) do
    instance_double(
      AiLocalizer::Configuration,
      source_lang: from_lang,
      target_langs: target_langs,
      translator_engine: 'gemini',
      source_file_paths: [template_file_path],
      formality: nil,
      translation_length_intensity: nil,
      max_translation_length_ratio: nil,
      use_existing_translations: true
    )
  end

  describe 'version' do
    it 'has a version number' do
      expect(AiLocalizer::VERSION).not_to be nil
    end
  end

  describe 'create_locales' do
    let(:fr_engine) { AiLocalizer::Engines::Gemini::Engine.new(from_lang: 'en', to_lang: 'fr') }
    let(:es_engine) { AiLocalizer::Engines::Gemini::Engine.new(from_lang: 'en', to_lang: 'es') }

    before do
      allow(AiLocalizer).to receive(:config).and_return(configuration)
      allow(AiLocalizer::Services::FileTranslatorService).to receive(:call)
      allow(AiLocalizer::Utils::TranslationEngineSelector).to receive(:call).with(
        engine_type: configuration.translator_engine,
        from_lang: 'en',
        to_lang: 'fr'
      ).and_return(fr_engine)
      allow(AiLocalizer::Utils::TranslationEngineSelector).to receive(:call).with(
        engine_type: configuration.translator_engine,
        from_lang: 'en',
        to_lang: 'es'
      ).and_return(es_engine)
    end

    it 'creates i18n files' do
      AiLocalizer.create_locales(template_file_path:)

      expect(AiLocalizer::Services::FileTranslatorService).to have_received(:call).with(
        template_file_path:,
        engine: fr_engine,
        translation_settings: {
          from_lang:,
          to_lang: 'fr',
          formality: nil,
          max_translation_length_ratio: nil,
          translation_length_intensity: nil,
          use_existing_translations: true
        }
      )

      expect(AiLocalizer::Services::FileTranslatorService).to have_received(:call).with(
        template_file_path:,
        engine: es_engine,
        translation_settings: {
          from_lang:,
          to_lang: 'es',
          formality: nil,
          max_translation_length_ratio: nil,
          translation_length_intensity: nil,
          use_existing_translations: true
        }
      )
    end
  end
end
