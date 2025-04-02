# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Utils::YmlParser do
  it "parses a valid YML file" do
    result = described_class.new('spec/fixtures/valid.yml').call

    expect(result).to eq(
      [{
        context: nil,
        entry: nil,
        existing_translation: nil,
        index: ["en", "welcome"],
        original: "Hello AI translator!",
        parent_index: nil,
        path: "spec/fixtures/valid.yml",
        plural: nil,
        plural_count: nil,
        signature: "4b922c0b173c9de4a63ad9abb8f8d80f"
      }]
    )
  end
end
