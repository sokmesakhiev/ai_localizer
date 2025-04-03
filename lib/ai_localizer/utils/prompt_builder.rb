# frozen_string_literal: true

module AiLocalizer
  module Utils
    class PromptBuilder
      ALLOWED_LENGTH_CONSTRAIN_INTENSITY = %w[hard].freeze

      attr_reader :from_lang, :to_lang, :formality

      def initialize(from_lang:, to_lang:, formality: nil)
        @formality = formality
        @from_lang = from_lang
        @to_lang = to_lang
      end

      def render(content: nil)
        params = { source_language_name:, target_language_name:, formality_prompt: }

        user_prompt_parameters = if content.nil?
                                   params
                                 else
                                   params.merge(content:)
                                 end
        {
          system_prompt: interpolate(prompt_template[:system_prompt], params).chomp,
          user_prompt: interpolate(prompt_template[:user_prompt], user_prompt_parameters)
        }
      end

      private

      def translation_length_prompt
        return '' if translation_max_length.blank? || ALLOWED_LENGTH_CONSTRAIN_INTENSITY.exclude?(max_length_prompt_intensity)
        return @translation_length_prompt if defined?(@translation_length_prompt)

        length_prompt = case max_length_prompt_intensity
                        when 'hard'
                          prompt_template.hard_translation_length_prompt
                        else
                          ''
                        end

        @translation_length_prompt = interpolate(length_prompt, { translation_max_length: })
      end

      def formality_prompt
        @formality_prompt ||= case formality.to_s
                              when 'more'
                                prompt_template[:more_formality_prompt]
                              when 'less'
                                prompt_template[:less_formality_prompt]
                              else
                                prompt_template[:neutral_formality_prompt]
                              end
      end

      def interpolate(template, placeholders = {})
        template = template.to_s.dup
        placeholders.each do |key, value|
          template.gsub!("${{#{key}}}", value)
        end

        template
      end

      def prompt_template
        @prompt_template ||= load_prompts
      end

      def load_prompts
        gem_root = Gem.loaded_specs['ai_localizer'].full_gem_path
        file_path = File.join(gem_root, 'config', 'prompt.yml')
        prompts_data = YAML.load_file(file_path)

        prompts_data.transform_keys(&:to_sym) || {}
      end

      def source_language_name
        @source_language_name ||= AiLocalizer::Entities::Language::MAPPING[from_lang]
      end

      def target_language_name
        @target_language_name ||= AiLocalizer::Entities::Language::MAPPING[to_lang]
      end
    end
  end
end
