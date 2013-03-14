require 'sinatra/base'
require 'rack/mount'
require 'koda-content'
require 'koda-authorisation'
require 'koda-admin'
require 'koda-admin-authorisation'

module Koda
  class AuthorisedApi < Koda::Api
    use Koda::Authorisation
  end

  class AuthorisedAdmin < Koda::Admin
    use Koda::AdminAuthorisation
  end

  def self.create_application(app, use_authorisation = false)
    current_api =  use_authorisation ? AuthorisedApi : Koda::Api
    current_admin =  use_authorisation ? AuthorisedAdmin : Koda::Admin

    Rack::Mount::RouteSet.new do |set|
      set.add_route current_api, { :path_info => %r{^/api*} }
      set.add_route current_admin, { :path_info => %r{^/admin*} }
      set.add_route app, {path_info: /^*/}
    end
  end
end