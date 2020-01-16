require "rack"

module BasicAuth
  class Middleware < Rack::Auth::Basic
    # Override initialize to allow middleware options. IE:
    #
    #     use BasicAuth::Middleware, passwordfile: "htpasswd.txt"
    #
    def initialize(app, options={})
      @app, @options = app, options
      @passwordfile = options[:passwordfile] || "config/htpasswd"
    end

    def call(env)
      path = Rack::Request.new(env).path
      matcher = Matcher.new(path, @options)
      return @app.call(env) unless matcher.match? # passthrough if route doesnt match

      htpasswd = Htpasswd.new(@passwordfile)
      authorized = htpasswd.call(env)
      if authorized
        @app.call(env)
      else
        unauthorized # from Rack::Auth::Basic
      end
    end
  end
end
