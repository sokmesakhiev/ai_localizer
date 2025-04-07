namespace :ai_localizer do
  def indicator
    Proc.new do |dirname, lang|
      print "\033[37m -->  #{dirname} : #{lang} .. \033[32m done  \n"
    end
  end

  desc "Translate and create locales from source locale"
  task :translate, [:from_lang, :to_langs] => :environment do |t , args|
    locale_paths = JSON.parse(AiLocalizer.config.source_file_paths)
    from_lang = args[:from_lang]
    to_langs = args[:to_langs].split(',')

    locale_paths.each do |path|
      AiLocalizer.create_locales(template_file_path: path, from_lang:, to_langs:, indicator:)
    end
  end
end
