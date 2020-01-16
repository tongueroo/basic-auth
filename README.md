# basic-auth Middleware

[![Gem Version](https://badge.fury.io/rb/basic-auth.png)](http://badge.fury.io/rb/basic-auth)

[![BoltOps Badge](https://img.boltops.com/boltops/badges/boltops-badge.png)](https://www.boltops.com)

Basic Auth Rack Middleware that supports htpasswd files.  It works with Rack compatible frameworks like [Jets](https://rubyonjets.com/), [Rails](https://rubyonrails.org/), [Sinatra](http://sinatrarb.com/), etc.

## Sinatra Example

```ruby
require 'sinatra'
require 'basic-auth'

use BasicAuth::Middleware

get '/' do
  "42\n"
end
```

## Jets Example

config/application.rb:

```ruby
Jets.application.configure do
  config.middleware.use(BasicAuth::Middleware)
end
```

## Customizations

Option | Description
--- | ---
passwordfile | Path to the htpasswd file. Default: `config/htpasswd`
protect | Url patterns to protect. The default behavior is to protect all urls. Default: nil (results in protecting all).

Example:

```ruby
use BasicAuth::Middleware, passwordfile: "config/pass.txt", protect: %r{/area51}
```

The url paths under `/area51` will all be protected. Other urls like the homepage will not be protected.

## Cached htpasswd

The htpasswd file is loaded into memory and cached. This means any changes you make to htpasswd, like adding users, will require a server restart. If you want to disable the cache, use `BASIC_AUTH_NO_CACHE=1`.

## Generating htpasswd files

The `htpasswd` tool can be used to create htpasswd files. It is installed as part of the apache webserver.  It's general form is:

    htpasswd PASSWORDFILE USERNAME

Example:

    $ htpasswd htpasswd user
    New password:
    Re-type new password:
    Adding password for user user
    $

There are also online htpasswd generators: [Htpasswd Generator](http://www.htaccesstools.com/htpasswd-generator/)

## Installation

Add this line to your application's Gemfile:

    gem "basic-auth"

And then execute:

    bundle

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
