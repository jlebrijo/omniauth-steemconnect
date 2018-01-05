require 'omniauth-oauth2'

# require 'omniauth/strategies/steem_connect'
# sc = OmniAuth::Strategies::SteemConnect.new 'crowdini.app', '63e99efeff2d5dbae37b220d1774a7733bd5e25ad9881b92'

module OmniAuth
  module Strategies
    class Steemconnect < OmniAuth::Strategies::OAuth2
      option :client_options,
             site: 'https://v2.steemconnect.com/api',
             authorize_url: 'https://v2.steemconnect.com/oauth2/authorize',
             token_url: 'https://v2.steemconnect.com/api/oauth2/token'

      uid { raw_info['user'] }

      info do
        {
            username: raw_info['user']
        }
      end

      extra do
        {
            raw_info: raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/me').parsed || {}
      end

      def request_phase
        cb_url = URI(callback_url).to_s.gsub("?#{uri.query}",'')
        options[:authorize_params] = {
            scope: options['scope']
        }
        redirect client.auth_code.authorize_url({redirect_uri: cb_url}.merge(authorize_params))
      end
    end
  end
end