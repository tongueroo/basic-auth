require "basic_auth/version"

module BasicAuth
  class Error < StandardError; end

  autoload :Htpasswd, "basic_auth/htpasswd"
  autoload :Matcher, "basic_auth/matcher"
  autoload :Middleware, "basic_auth/middleware"
end
