# frozen_string_literal: true

module AiLocalizer
  module Engines
    module Gemini
      class Request
        attr_reader :access_token, :model

        def initialize(client_params)
          @access_token = client_params[:open_ai_access_token]
          @model = client_params[:open_ai_model]
        end

        def execute(system_prompt, user_prompt)
          Faraday.post("https://generativelanguage.googleapis.com/v1beta/models/#{model}:generateContent") do |req|
            req.params['key'] = access_token
            req.headers['Content-Type'] = 'application/json'
            req.body = {
              contents: [
                {
                  parts: [
                    { text: "Explain how AI works" }
                  ]
                }
              ]
            }
          end
        end
      end
    end
  end
end
