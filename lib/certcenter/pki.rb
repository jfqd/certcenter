require 'openssl'

module Certcenter
  
  # Source from: https://gist.github.com/aspyatkin/23c336b811aac211040f
  # Usage example
  # generate_csr(
  #   'acme.com',
  #   'ACME Corp.',
  #   'US',
  #   'California',
  #   'San Francisco',
  #   [ 'acme.com', 'www.acme.com', 'api.acme.com', 'cdn.acme.com' ]
  # )
  class Pki
    
    KEYSIZE = 4096
    
    # Generate X509 CSR (certificate signing request) with SAN (Subject Alternative Name) extension and sign it with the RSA key
    def self.generate_csr(common_name, organization, country, state_name, locality, domain_list)
      # create signing key
      signing_key = OpenSSL::PKey::RSA.new Pki::KEYSIZE
      
      # create certificate subject
      subject = OpenSSL::X509::Name.new [
        ['CN', common_name],
        ['O',  organization],
        ['C',  country],
        ['ST', state_name],
        ['L',  locality]
      ]
      
      # create CSR
      csr = OpenSSL::X509::Request.new
      csr.version = 0
      csr.subject = subject
      csr.public_key = signing_key.public_key
      
      if domain_list != nil && domain_list != []
        # prepare SAN extension
        san_list = domain_list.map { |domain| "DNS:#{domain}" }
        extensions = [
          OpenSSL::X509::ExtensionFactory.new.create_extension('subjectAltName', san_list.join(','))
        ]
        # add SAN extension to the CSR
        attribute_values = OpenSSL::ASN1::Set [OpenSSL::ASN1::Sequence(extensions)]
        [
          OpenSSL::X509::Attribute.new('extReq', attribute_values),
          OpenSSL::X509::Attribute.new('msExtReq', attribute_values)
        ].each do |attribute|
          csr.add_attribute attribute
        end
      end
      
      # sign CSR with the signing key
      csr.sign signing_key, OpenSSL::Digest::SHA256.new
      
      return [signing_key.to_pem,csr.to_pem]
    end
    
  end
end