namespace :ai_localizer do
  desc 'Translate and create locales from source locale'
  # print "\033[37m --> Processing #{path} : #{lang} .. \033[32m done  \n"

  task translate: :environment do
    locale_paths = AiLocalizer.config.source_file_paths

    locale_paths.each do |template_file_path|
      AiLocalizer.create_locales(template_file_path:)
    end
    print "\e[32m --> Done  .. \n\n"
  end
end
