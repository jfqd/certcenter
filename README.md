# Certcenter

Ruby API to order (free domain validated) certificates from Certcenter AG.

## Installation

Add this line to your application's Gemfile:

  gem 'certcenter'

And then execute:

  bundle

Or install it yourself as:

  gem install certcenter

## Usage

```ruby
require 'certcenter'

common_name  = "example.com"
organization = "Example Inc."
country      = "US"
state_name   = "California"
locality     = "San Francisco"
domain_list  = ["www.example.com","mail.example.com"] # note: not for AlwaysOnSSL certs!
oauth_token  = "XYZXYZXYZXYZXYZXYZXYZ.oauth2.certcenter.com"

cr = Certcenter.new(common_name, organization, country, state_name, locality, domain_list, oauth_token)

if cr.valid?

  # Returns an array like:
  # [ "cname.example.com.", "orig.example.com."]
  cname = cr.dns_data
  
  # Now create a CNAME entry for order approval
  # cname.example.com. IN CNAME orig.example.com.
  
  # Order the signed certificate
  if cr.order
    puts [cr.key, cr.intermediate, cr.crt]
  end
end
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Copyright

Copyright (c) 2016 Stefan Husch, qutic development
