# frozen_string_literal: true

module AiLocalizer
  module Entities
    class SourceBlock
      attr_reader :object, :opts

      def initialize(object, opts = {})
        @object = object
        @opts = opts
      end

      def index
        opts[:index]
      end

      def original
        opts[:original]
      end

      def path
        opts[:path]
      end

      def signature
        AiLocalizer::Utils::SignatureGenerator.new(block: self).call
      end

      def try(method_name)
        send(method_name) rescue nil
      end

      def self.decorate(relation, **context)
        new(relation, context)
      end
    end
  end
end
