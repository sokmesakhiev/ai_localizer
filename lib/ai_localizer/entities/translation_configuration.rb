# frozen_string_literal: true

module AiLocalizer
  module Entities
    class TranslationConfiguration
      def initialize(from: nil, to: nil, engine: nil, placeholder_formats: nil, placeholder_map: {}, placeholder_backward_map: {}, signature: nil)
        @engine = engine
        @placeholder_formats = placeholder_formats
        @placeholder_backward_map = placeholder_backward_map
        @placeholder_map = placeholder_map
        @from = from
        @to = to
        @failed = {}
        @processed_source = {}
        @signature = signature
      end

      def processed_source(id:)
        @processed_source[id]
      end

      def failed?(id:)
        @failed[id].present?
      end

      def processed_source?(id:)
        @processed_source[id].present?
      end

      def set_processed_source(id:, value:)
        @processed_source[id] = value
      end

      def set_failed(id:)
        @failed[id] = true
      end

      attr_reader :from, :to, :engine, :placeholder_formats, :placeholder_backward_map, :placeholder_map
      attr_accessor :signature
    end
  end
end
