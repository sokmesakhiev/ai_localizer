# frozen_string_literal: true

module AiLocalizer
  module Services
    class Base
      def self.call(**args)
        new(**args).call
      end
    end
  end
end
