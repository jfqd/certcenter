module Certcenter

  class Api
    
    def initialize(common_name, organization, country, state_name, locality, domain_list, oauth_token, product_code)
      domain_list   = nil if product_code.include?("AlwaysOnSSL") # no support for san for the moment
      @common_name  = common_name
      @csr          = csr
      @product_code = product_code
      @oauth_token  = oauth_token
      @key, @csr    = Certcenter::Pki.generate_csr(common_name, organization, country, state_name, locality, domain_list)
      @crt          = nil
      @intermediate = nil
    end
    
    def csr
      @csr
    end
    
    def key
      @csr
    end
    
    def products
      r = Certcenter.server(@oauth_token).get("Products")
      puts r
      r["Products"]
    rescue ResponseException => e
      return e
    end
    
    def valid?
      h = { "CommonName" => @common_name }
      r = Certcenter.server(@oauth_token).post("ValidateName", h)
      r["IsQualified"] == true
    rescue ResponseException => e
      return e
    end
    
    def dns_data
      h = { "ProductCode" => @product_code, "CSR" => @csr }
      r = Certcenter.server(@oauth_token).post("DNSData", h)
      [ r["DNSAuthDetails"]["DNSEntry"], r["DNSAuthDetails"]["DNSValue"] ]
    rescue ResponseException => e
      return e
    end
    
    def order
      h = { "OrderParameters" => { "ProductCode" => @product_code, "CSR" => @csr, "ValidityPeriod" => 365 } }
      r = Certcenter.server(@oauth_token).post("Order", h)
      puts r.inspect
      @intermediate = r["Fulfillment"]["Intermediate"]
      @crt = r["Fulfillment"]["Certificate"]
      true
    rescue ResponseException => e
      return e
    end
    
    def intermediate
      @intermediate
    end
    
    def crt
      @crt
    end
    
  end
  
end
