
namespace :ai_localizer do
  desc "Translate and create locales from source locale"
  # print "\033[37m --> Processing #{path} : #{lang} .. \033[32m done  \n"

  task translate: :environment do |t , args|
    locale_paths = AiLocalizer.config.source_file_paths

    locale_paths.each do |path|
      AiLocalizer.create_locales(path:)
    end
  end
end
