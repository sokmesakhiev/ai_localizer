# frozen_string_literal: true

module AiLocalizer
  module Utils
    class PromptBuilder
      attr_reader :from_lang, :to_lang, :formality, :max_translation_length_ratio, :translation_length_intensity

      def initialize(from_lang:, to_lang:, formality: nil, max_translation_length_ratio: nil, translation_length_intensity: nil)
        @formality = formality
        @max_translation_length_ratio = max_translation_length_ratio
        @translation_length_intensity = translation_length_intensity
        @from_lang = from_lang
        @to_lang = to_lang
      end

      def build_prompt(content: nil)
        params = { source_language_name:, target_language_name:, formality_prompt:, restrict_translation_length_result_prompt: }

        user_prompt_parameters = content.nil? ? params : params.merge(content:)

        {
          system_prompt: interpolate(prompt_template[:system_prompt], params).chomp,
          user_prompt: interpolate(prompt_template[:user_prompt], user_prompt_parameters)
        }
      end

      def self.load_prompts
        gem_root = Gem.loaded_specs['ai_localizer'].full_gem_path
        file_path = File.join(gem_root, 'config', 'prompt.yml')
        prompts_data = YAML.load_file(file_path)

        prompts_data.transform_keys(&:to_sym) || {}
      end

      private

      def restrict_translation_length_result_prompt
        return '' if max_translation_length_ratio.blank?

        return @restrict_translation_length_result_prompt if defined?(@restrict_translation_length_result_prompt)

        percentage = ((max_translation_length_ratio.to_f * 100) - 100).to_s

        length_prompt = case translation_length_intensity
                        when 'strict'
                          prompt_template[:strict_length_prompt]
                        when 'soft'
                          prompt_template[:soft_length_prompt]
                        else
                          ''
                        end

        @restrict_translation_length_result_prompt = interpolate(length_prompt, { percentage: })
      end

      def formality_prompt
        @formality_prompt ||= case formality.to_s
                              when 'formal'
                                prompt_template[:formality_prompt]
                              when 'informal'
                                prompt_template[:informality_prompt]
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
        @prompt_template ||= self.class.load_prompts
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
