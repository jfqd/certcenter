# Certcenter

Ruby API to order (free so called AlwaysOnSSL domain validated) certificates from Certcenter AG.

**WARNING**: Do not use the certificate service from Certcenter AG! Unless you are willing to change
your code all the time to get it working again, because they change the api without letting you
know about it! They do not understand that breaking changes need to be done by increasing the
api-version! And if you tell them, they do not even care about it.You should better use Let’s Encrypt.

## Installation

Add this line to your application's Gemfile:

```
gem 'certcenter'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install certcenter
```

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
