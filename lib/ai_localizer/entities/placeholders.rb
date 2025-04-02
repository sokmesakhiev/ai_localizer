# frozen_string_literal: true

module AiLocalizer
  module Entities
    class Placeholders
      OPEN_TAG = '<\s*[a-zA-Z][a-zA-Z0-9]*\s*[^>]*>'
      CLOSE_TAG = '<\/[^>]*>'

      DEFAULT_PLACEHOLDERS = [
        OPEN_TAG,
        CLOSE_TAG,
        '\%\{\w+\}'
      ]
    end
  end
end
