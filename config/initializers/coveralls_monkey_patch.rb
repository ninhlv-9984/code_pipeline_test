return unless (Rails.env.test? || Rails.env.development?) && ENV["CI"]

require 'json'
require 'rest-client'
require 'coveralls'

module Coveralls
  class API
    def self.post_json(endpoint, hash)
      disable_net_blockers!

      uri = endpoint_to_uri(endpoint)

      Coveralls::Output.puts("#{ JSON.pretty_generate(hash) }", :color => "green") if ENV['COVERALLS_DEBUG']
      Coveralls::Output.puts("[Coveralls] Submitting to #{API_BASE}", :color => "cyan")


      hash = apified_hash(hash)
      response = RestClient.post(uri.to_s, json_file: hash_to_file(hash))

      response_hash = JSON.parse(response)

      if response_hash['message']
        Coveralls::Output.puts("[Coveralls] #{ response_hash['message'] }", :color => "cyan")
      end

      if response_hash['url']
        Coveralls::Output.puts("[Coveralls] #{ Coveralls::Output.format(response_hash['url'], :color => "underline") }", :color => "cyan")
      end

      case response
      when Net::HTTPServiceUnavailable
        Coveralls::Output.puts("[Coveralls] API timeout occured, but data should still be processed", :color => "red")
      when Net::HTTPInternalServerError
        Coveralls::Output.puts("[Coveralls] API internal error occured, we're on it!", :color => "red")
      end
    end
  end
end
