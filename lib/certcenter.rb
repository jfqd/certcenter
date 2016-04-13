require "certcenter/version"
require "certcenter/http"
require "certcenter/api"
require "certcenter/pki"

module Certcenter
  
  ALWAYSONSSL = "AlwaysOnSSL.AlwaysOnSSL"
  
  # Wrapper Method
  def self.new(common_name, organization, country, state_name, locality, domain_list=[], oauth_token="", product_code=Certcenter::ALWAYSONSSL)
    ::Certcenter::Api.new(common_name, organization, country, state_name, locality, domain_list, oauth_token, product_code)
  end
  
end
