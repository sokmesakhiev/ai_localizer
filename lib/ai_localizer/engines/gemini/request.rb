# frozen_string_literal: true

module AiLocalizer
  module Engines
    module Gemini
      class Request
        attr_reader :api_key, :model

        def initialize(client_params)
          @api_key = client_params[:gemini_api_key]
          @model = client_params[:gemini_model]
        end

        def execute(system_prompt, user_prompt)
          payload = [system_prompt, user_prompt].join("\n")

          Faraday.post("https://generativelanguage.googleapis.com/v1beta/models/#{model}:generateContent") do |req|
            req.params['key'] = api_key
            req.headers['Content-Type'] = 'application/json'
            req.body = {
              contents: [
                {
                  parts: [
                    { text: payload }
                  ]
                }
              ]
            }.to_json
          end
        end
      end
    end
  end
end
