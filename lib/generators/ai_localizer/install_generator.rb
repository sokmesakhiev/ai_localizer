require 'rails/generators'

module AiLocalizer
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def create_initializer_file
      copy_file 'ai_localizer_initializer.rb', 'config/initializers/ai_localizer.rb'
      copy_file 'ai_localizer.rake', 'lib/tasks/ai_localizer.rake'
      copy_file 'ai_localizer.yml', 'config/ai_localizer.yml'
    end
  end
end
