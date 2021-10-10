class ApplicationController < ActionController::API
    include Response
    include ExceptionHandler
    require 'oauth2'
    require 'uri'
    require 'faraday'
    require 'json'
    require 'time'

    SITE_URL = "https://auth.aweber.com"
    AUTH_URL = '/oauth2/authorize'
    TOKEN_URL = '/oauth2/token'
    REDIRECT_URI = 'https://apiesp.herokuapp.com/'

    scopes = [
        'account.read',
        'list.read',
        'list.write',
        'subscriber.read',
        'subscriber.write',
        'email.read',
        'email.write',
        'subscriber.read-extended',
        'landing-page.read'
    ]
    SCOPE = scopes.join(" ")

    class Encoder
        def self.encode(hash)
            URI.encode_www_form(hash)
        end

        def self.decode(string)
            URI.decode_www_form(hash)
        end
    end

    def get_token(url_token)
        credentials = {}
        credentials[:client_id]  = ENV['CLIENT_ID']
        credentials[:client_secret] = ENV['CLIENT_SECRET_ID']

        client = OAuth2::Client.new(
            credentials[:client_id], 
            credentials[:client_secret], 
            :site => SITE_URL,
            :authorize_url => AUTH_URL,
            :token_url => TOKEN_URL,
            :connection_opts => {
            :request => {
                params_encoder: Encoder
            }
            },
            :scope => SCOPE
        )

        auth_url = client.auth_code.authorize_url(
        :redirect_uri => REDIRECT_URI,
        :scope => SCOPE
        )

        response_url = url_token

        code = CGI.parse(URI.parse(response_url).query)["code"].first

        token = client.auth_code.get_token(
            code,
            :redirect_uri => REDIRECT_URI
        )
        credentials[:access_token] = token.token
        credentials[:refresh_token] = token.refresh_token

        File.open("./credentials.json","w") do |f|
            f.write(credentials.to_json)
        end
        return token.token
    end

    def refresh_token(method)
        credentials = JSON.parse(File.read("./credentials.json"))

        client = OAuth2::Client.new(
            credentials["client_id"],
            credentials["client_secret"],
            :site => SITE_URL,
            :authorize_url => AUTH_URL,
            :token_url => TOKEN_URL,
            :scope => SCOPE
        )
        
        token = OAuth2::AccessToken.new(
            client,
            credentials["access_token"],
            {
                refresh_token: credentials["refresh_token"],
                :scope => SCOPE
            }
        )
        new_token = token.refresh!(:scopes => SCOPE)

        credentials[:access_token] = new_token.token
        credentials[:refresh_token] = new_token.refresh_token

        File.open("./credentials.json","w") do |f|
            f.write(credentials.to_json)
        end

        return new_token.token
        redirect_to method
    end

    def get_accounts
        credentials = JSON.parse(File.read("./credentials.json"))

        headers = {
        'Accept': 'application/json',
        'User-Agent': 'api-esp-Ideaware/1.0',
        'Authorization': "Bearer #{credentials["access_token"]}"
        }
        response = Faraday.get(
        "https://api.aweber.com/1.0/accounts"
        ) do |req|
            req.headers = headers
        end

        if response.status.to_s == '401'
            redirect_to refresh_token('get_accounts')
        else
            account_id = JSON.parse(response.body)['entries'][0]['id']
            return account_id
        end
    end

    def get_lists
        account_id = get_accounts
        
        credentials = JSON.parse(File.read("./credentials.json"))
        headers = {
        'Accept': 'application/json',
        'User-Agent': 'api-esp-Ideaware/1.0',
        'Authorization': "Bearer #{credentials["access_token"]}"
        }
        response = Faraday.get(
        "https://api.aweber.com/1.0/accounts/#{account_id}/lists", 
        ) do |req|
            req.headers = headers
        end

        if response.status.to_s == '401'
            redirect_to refresh_token('get_lists')
        else
            list_id = JSON.parse(response.body)['entries'][0]['id']
            return account_id, list_id
        end
    end

    def send_to_aweber(c)
        ids = get_lists
        account_id = ids[0]
        list_id = ids[1]
    
        credentials = JSON.parse(File.read("./credentials.json"))
        access_token = credentials["access_token"]
    
        if c.send_information_status == 'true'
          send_information_status = 'opted-in'
          number_sent = 0
        elsif c.send_information_status == 'false'
          number_sent = 1001
        end
    
        headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'User-Agent': 'api-esp-Ideaware/1.0',
          'Authorization': "Bearer #{access_token}"
        }
        body = {
          'custom_fields': {
            'telefono': c.telefono,
            'send-information-status': send_information_status
          },
          'email': c.correo,
          'last_followup_message_number_sent': number_sent,
          'name': c.nombre,
          'strict_custom_fields': true
        }
        response = Faraday.post(
          "https://api.aweber.com/1.0/accounts/#{account_id}/" \
          "lists/#{list_id}/subscribers"
        ) do |req|
          req.headers = headers
          req.body = body.to_json
        end
    
        if response.status.to_s == '201'
          c.sent_aweber = 'Success'
        else
          c.sent_aweber = 'Error'
        end
        c.save!
    end
end