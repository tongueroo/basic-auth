RSpec.describe BasicAuth::Middleware do
  let(:app) { Proc.new { [200, {}, ["ok"]] } }

  context "middleware with default protect will protect all" do
    let(:middleware) do
      BasicAuth::Middleware.new(app, passwordfile: "spec/fixtures/htpasswd.txt")
    end

    it "valid user and pass" do
      encoded = Base64.encode64('user:pass').strip # dXNlcjpwYXNz
      env = Rack::MockRequest.env_for("/", {"HTTP_AUTHORIZATION" => "Basic #{encoded}"})
      result = middleware.call(env)
      expect(result).to eq [200, {}, ["ok"]]
    end

    it "invalid user and pass" do
      encoded = Base64.encode64('invalid:invalid').strip
      env = Rack::MockRequest.env_for("/", {"HTTP_AUTHORIZATION" => "Basic #{encoded}"})
      result = middleware.call(env)
      unauthorized = [401, {"Content-Length"=>"0", "Content-Type"=>"text/plain", "WWW-Authenticate"=>"Basic realm=\"\""}, []]
      expect(result).to eq unauthorized
    end
  end

  context "middleware with frontdoor protection" do
    let(:middleware) do
      BasicAuth::Middleware.new(app, passwordfile: "spec/fixtures/htpasswd.txt", protect: "/frontdoor")
    end

    it "homepage" do
      env = Rack::MockRequest.env_for("/", {}) # no HTTP_AUTHORIZATION info
      result = middleware.call(env)
      expect(result).to eq [200, {}, ["ok"]] # allows through since / is not /frontdoor
    end

    it "frontdoor" do
      env = Rack::MockRequest.env_for("/frontdoor", {})
      result = middleware.call(env)
      unauthorized = [401, {"Content-Length"=>"0", "Content-Type"=>"text/plain", "WWW-Authenticate"=>"Basic realm=\"\""}, []]
      expect(result).to eq unauthorized
    end
  end
end
