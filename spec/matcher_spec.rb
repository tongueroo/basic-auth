RSpec.describe BasicAuth::Matcher do
  def match(path, protect)
    BasicAuth::Matcher.new(path, protect: protect).match?
  end

  context "protect nil" do
    it "path /" do
      matched = match("/", nil)
      expect(matched).to be true
    end

    it "path /foo" do
      matched = match("/", nil)
      expect(matched).to be true
    end
  end

  context "protect / exact match" do
    let(:protect) { %r{^/$} }
    it "path /" do
      matched = match("/", protect)
      expect(matched).to be true
    end

    it "path /foo" do
      matched = match("/foo", protect)
      expect(matched).to be false
    end
  end

  context "protect /frontdoor" do
    let(:protect) { %r{^/frontdoor} }
    it "path /frontdoor" do
      matched = match("/frontdoor", protect)
      expect(matched).to be true
    end

    it "path /frontdoor/is/locked" do
      matched = match("/frontdoor/is/locked", protect)
      expect(matched).to be true
    end

    it "path /backdoor" do
      matched = match("/backdoor", protect)
      expect(matched).to be false
    end
  end

  context "protect /frontdoor as string" do
    let(:protect) { "/frontdoor" }
    it "path /frontdoor" do
      matched = match("/frontdoor", protect)
      expect(matched).to be true
    end
  end
end
