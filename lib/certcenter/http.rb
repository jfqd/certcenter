require 'uri'
require 'net/http'
require 'net/https'
require 'json'
require 'logger'

module Certcenter
  
  # Default logger that silences all diagnostic output.
  LOGGER = Logger.new("/dev/null")
  SCHEMA = "https"
  HOST   = "api.certcenter.com"
  PORT   = 443
  
  def self.server(oauth_token=nil)
    @server ||= ::Certcenter.v1.http(oauth_token: oauth_token)
  end
  
  def self.v1
    V1.new
  end
  
  class V1
    def http(schema: SCHEMA, host: HOST, port: PORT, oauth_token: oauth_token, logger: LOGGER)
      HTTP.new(schema: schema, host: host, port: port, oauth_token: oauth_token, logger: logger)
    end
  end
  
  ResponseException = Class.new(StandardError)
  
  class HTTP
    
    def initialize(schema:, host:, port:, oauth_token:, logger:)
      @schema      = schema
      @host        = host
      @port        = port
      @oauth_token = oauth_token
      @logger      = logger
    end
    
    def get(request_uri, data = nil)
      url = "#{base_uri}/#{request_uri}"
      response = https_request(:get, url, data)
      parse_body(response)
    end
    
    def post(request_uri, data = nil)
      url = "#{base_uri}/#{request_uri}"
      response = https_request(:post, url, data)
      parse_body(response)
    end
    
    attr_accessor :logger
    
    protected
    
    def base_uri
      "#{@schema}://#{@host}:#{@port}/rest/v1"
    end
    
    def parse_body(response)
      JSON.parse("[#{response.body}]")[0] rescue nil
    end
    
    def https_request(method, url, data = nil)
      method = {
        get:    Net::HTTP::Get,
        post:   Net::HTTP::Post,
        put:    Net::HTTP::Put,
        delete: Net::HTTP::Delete
      }.fetch(method)
      
      uri           = URI.parse(url)
      https         = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request       = method.new(uri.path, {"Authorization" => "Bearer #{ @oauth_token }",
                                            "Content-Type"  => "application/json"})
      request.body  = data.to_json if data
      response      = https.request(request)
      
      if response.code.to_i >= 400
        raise ResponseException, "#{response.code} on #{uri}: #{response.message}"
      end
      
      response
    end
  end

end
