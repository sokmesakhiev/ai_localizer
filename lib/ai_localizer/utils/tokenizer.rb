# frozen_string_literal: true

module AiLocalizer
  module Utils
    class Tokenizer
      TOKEN_SIZE = 8

      PRESERVE_TOKENS = [
        "\\[\\%html\#\\d{#{TOKEN_SIZE}}\\]",
        "\\[\\/\\%html\\#\\d{#{TOKEN_SIZE}}\\]",
        "\\[\\%[g|n]\\#\\d{#{TOKEN_SIZE}}\\]",
        '\[\%[g|n]\#ThisIsAName\w+\]'
      ].freeze

      def self.generate_token(token_root:, length: 5, type: nil)
        case type
        when 'open_html_tag'
          get_open_html_tag_token(token_root:, length:)
        when 'close_html_tag'
          get_close_html_tag_token(token_root:, length:)
        else
          get_stand_alone_token(token_root:, length:)
        end
      end

      def self.get_stand_alone_token(token_root: nil, length: 5)
        token = get_token(token_root:, length:)

        "%p##{token}"
      end

      def self.get_open_html_tag_token(token_root: nil, length: 5)
        token = get_token(token_root:, length:)

        "[%html##{token}]"
      end

      def self.get_close_html_tag_token(token_root: nil, length: 5)
        token = get_token(token_root: token_root.delete('/'), length:)

        "[/%html##{token}]"
      end

      def self.get_token(token_root:, length:)
        result = (token_root.nil? ? SecureRandom.hex((length.to_f / 2).ceil) : Digest::MD5.hexdigest(token_root))[0..length]

        result.to_i(16).to_s.rjust(TOKEN_SIZE, '0')
      end
    end
  end
end
