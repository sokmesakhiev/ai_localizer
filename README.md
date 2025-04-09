# AI Localizer
[![Gem Version](https://badge.fury.io/rb/ai_localizer.svg)](https://rubygems.org/gems/ai_localizer)
[![Build Status](https://github.com/sokmesakhiev/ai_localizer/workflows/Publish%20Gem/badge.svg)](https://github.com/sokmesakhiev/ai_localizer/actions?query=workflow%3A%22Publish%20Gem%22)
[![Dependabot](https://img.shields.io/badge/dependabot-enabled-success.svg)](https://dependabot.com)

### AI Localizer – Effortless i18n Translation with LLMs

**AI Localizer** is a powerful Ruby gem designed to streamline internationalization (i18n) by leveraging Large Language Models (LLMs) to automatically translate localization files into multiple target languages. It simplifies the translation workflow for Rails applications using structured i18n files (YAML).

#### 🔹 **Key Features**
- **Automated Translations**: Uses AI to generate high-quality translations for i18n files.
- **Multiple Target Languages**: Easily translate your app’s content into various languages in a single command.
- **Seamless Integration**: Works with standard i18n formats (YAML) for easy adoption in Rails and other frameworks.
- **Customizable & Extensible**: Supports fine-tuning translation models and integrating with different AI providers.

With `ai_localizer`, you can eliminate manual translation efforts, reduce errors, and keep your application multilingual with minimal hassle.

**Start localizing smarter today!**

## ⚙️  Installation

Add this line to your application's Gemfile:

```ruby
gem 'ai_localizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ai_localizer

## 🚀 Usage

After installing the gem, run the installer to generate the initializer:

```bash
rails generate ai_localizer:install
```

This will create a configuration file at:

```
config/initializers/ai_localizer.rb
```

### 🔧 Configuration

In the generated initializer, you can configure the gem's behavior. Here's what you need to set:

#### 🇰🇭Choose Your Language Option

Set `config.source_lang` to select a source language for translation.

**Example:**

```ruby
config.source_lang = "en"
```

Set `config.target_langs` to select a target language for translation.

**Example:**

```ruby
config.target_langs = "['kh', 'fr', 'es']"
```

#### 📖 Choose Your Translation Formality

Set `config.formality` to select a formality level for translation.

- `'formal'`
- `'informal'`

**Example:**

```ruby
# Optional
config.formality = "formal"
```

#### ⏲ Choose Your Translation Length Intensity

Translation length intensity is an option that strictly limits the length of the translated text relative to the original string. This helps prevent UI layout issues when switching between languages. To enable this, set the max_translation_length_ratio, which defines the maximum allowed length of the translation compared to the original.

Set `config.max_translation_length_ratio` to select a maximum length ratio for translation.

Set `config.translation_length_intensity` to select a length intensity level for translation.

- `'soft'`
- `'strict'`

**Example:**

```ruby
# Optional
config.translation_length_intensity = "strict"
config.max_translation_length_ratio = 1.2
```

#### 🔤 Choose Your Translator Engine

Set `config.translator_engine` to select a translation provider. Available options:

- `'bedrock'`
- `'anthropic'`
- `'deepseek'`
- `'open_ai'`

#### 📁 Define Source File Paths

Set `config.source_file_paths` to specify which i18n files you want to translate. Use the `{{lang}}` placeholder to denote the language code.

**Example:**

```ruby
config.source_file_paths = ['config/locales/{{lang}}.yml']
```

If your source file is `config/locales/en.yml` and you want to translate to French and Spanish, the gem will generate:

- `config/locales/fr.yml`
- `config/locales/es.yml`

The gem will use `en` as the source language and create the others based on your settings.

#### 🔐 Provide API Credentials

Each translation engine requires specific credentials. You can provide these values in either:

- the initializer (`config/ai_localizer.rb`), or
- your `application.yml` (via [Figaro](https://github.com/laserlemon/figaro)).

**Anthropic example (via `application.yml`):**

```yaml
ANTHROPIC_API_KEY: "your_api_key"
ANTHROPIC_API_VERSION: "2023-06-01"
ANTHROPIC_MODEL: "claude-3-7-sonnet-20250219"
```

Similar variables are available for `bedrock`, `deepseek`, and `open_ai`.

---

## 🎯 Translating I18n Files

Once you've completed the configuration, you can translate your files by running:

```bash
bundle exec rails ai_localizer::translate
```

The gem will read your source file(s), perform the translation using the selected engine, and generate the corresponding target locale files.

---

## 🌐 Translating Text with API

You can also use the gem’s API to translate custom strings:

```ruby
AiLocalizer::Api::Translator.new(
  texts: ['hello'],
  from_lang: 'en',
  to_lang: 'fr',
  formality: 'formal',                   # optional
  max_translation_length_ratio: 1.2      # optional
)
```

This will translate `"hello"` from English to French, with optional parameters:

- `formality`: request formal translation
- `max_translation_length_ratio`: limit result to 120% of original string length

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sokmesakhiev/ai_localizer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AiLocalizer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ai_localizer/blob/master/CODE_OF_CONDUCT.md).
