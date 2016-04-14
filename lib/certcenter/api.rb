module Certcenter

  class Api
    
    def initialize(common_name, organization, country, state_name, locality, domain_list, oauth_token, product_code)
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
      @intermediate = r["OrderParameters"]["Fulfillment"]["Intermediate"]
      @crt = r["OrderParameters"]["Fulfillment"]["Certificate"]
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
