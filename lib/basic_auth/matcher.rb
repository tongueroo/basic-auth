module BasicAuth
  class Matcher
    def initialize(path, options={})
      @path, @options = path, options
      @protect = options[:protect]
    end

    def match?
      return true unless @protect # defaults to protect all
      # If user accidentally sets a string, change to a regexp
      pattern = @protect.is_a?(String) ? Regexp.new(@protect) : @protect
      matched = @path =~ pattern
      !!matched
    end
  end
end
