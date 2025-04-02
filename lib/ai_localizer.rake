namespace :i18n do
  def indicator
    Proc.new do |dirname, lang|
      print "\033[37m -->  #{dirname} : #{lang} .. \033[32m done  \n"
    end
  end

  desc "Translate and create locales from source locale"
  task :translate, [:from_lang, :to_langs] => :environment do |t , args|
    locale_paths = AiLocalizer.config.source_file_paths

    locale_paths.each do |path|
      from_lang = args[:from_lang]
      to_langs = args[:to_langs].split(',')

      AiLocalizer.create_locales(path:, from_lang:, to_langs:, indicator:)
    end
  end
end
