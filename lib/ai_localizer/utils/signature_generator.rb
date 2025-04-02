# frozen_string_literal: true

module AiLocalizer
  module Utils
    class SignatureGenerator
      attr_reader :block

      def initialize(block:)
        @block = block
      end

      def call
        Digest::MD5.hexdigest("#{block.path}#{block.index}#{block.original}")
      end
    end
  end
end
