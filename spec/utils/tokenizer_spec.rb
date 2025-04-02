# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AiLocalizer::Utils::Tokenizer do
  it 'tokenizes placeholders' do
    expect(described_class.generate_token(token_root: '%{name}')).to eq('%p#01683305')
    expect(described_class.generate_token(token_root: '<div>', type: 'open_html_tag')).to eq('[%html#03281493]')
    expect(described_class.generate_token(token_root: '</div>', type: 'close_html_tag')).to eq('[/%html#03281493]')
  end
end
