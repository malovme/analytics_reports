require 'googleauth'

class SessionsController < ApplicationController

  SCOPE = ['https://www.googleapis.com/auth/analytics.readonly']

  def oauth
    if session.has_key?(:credentials)
      client_opts = JSON.parse(session[:credentials])
      credentials = Signet::OAuth2::Client.new(client_opts)
    else
      credentials = nil
    end
    if credentials.nil? || credentials.expired?
      authorizer = get_authorizer SCOPE
      if request['code'].nil?
        url = authorizer.get_authorization_url(request: request)
        return redirect_to url
      else
        credentials = authorizer.get_credentials_from_code(code: request['code'], base_url: oauth_url)
        session[:credentials] = credentials.to_json
      end
    end

    redirect_to session[:redirect_path]
  end

  def destroy
    session[:credentials] = nil
    redirect_to root_path
  end

  private

  def get_authorizer scope
    client_id = Google::Auth::ClientId.new(Rails.application.secrets.google_auth_client_id,
                                           Rails.application.secrets.google_auth_client_secret)
    authorizer = Google::Auth::WebUserAuthorizer.new(client_id, scope, nil, oauth_url)
  end

end
