module Codifligne
  class API
    DEFAULT_TIMEOUT  = 30
    DEFAULT_FORMAT   = 'xml'
    DEFAULT_BASE_URL = "http://codifligne.stif.info/rest/v1/lc/getlist"

    attr_accessor :timeout, :format, :base_url

    def initialize(timeout: nil, format: nil)
      @timeout  = timeout || self.class.timeout || DEFAULT_TIMEOUT
      @format   = format || self.class.format || DEFAULT_FORMAT
      @base_url = self.class.base_url || DEFAULT_BASE_URL
    end

    def api_request(url)
      begin
        open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE, :read_timeout => @timeout)
      rescue Exception => e
        raise Codifligne::CodifligneError, "#{e.message} for request : #{url}."
      end
    end

    def parse_response(body)
      if body
        begin
          # Sometimes you need to be a Markup Nazi !
          doc = Nokogiri::XML(body) { |config| config.strict }
        rescue Exception => e
          raise Codifligne::CodifligneError, e.message
        end
      end
    end

    def lines(operator_name)
      url = URI.escape "#{self.base_url}/0/0/0/#{operator_name}/0/0/0/#{self.format}"
      doc = parse_response(api_request(url))

      attrs = {
        :name           => 'Name',
        :short_name     => 'ShortName',
        :transport_mode => 'TransportMode',
        :private_code   => 'PrivateCode'
      }
      inline_attrs = {
        :stif_id    => 'id',
        :status     => 'status',
        :created_at => 'created',
        :updated_at => 'changed'
      }

      doc.css('lines Line').map do |line|
        params = {}
        inline_attrs.map do |prop, xml_attr|
          params[prop] = line.attribute(xml_attr).to_s
        end
        attrs.map do |prop, xml_name|
          params[prop] = line.at_css(xml_name).content
        end
        params
      end.to_a
    end

    def operators
      url = "#{self.base_url}/0/0/0/0/0/0/0/#{self.format}"
      doc = parse_response(api_request(url))

      doc.css('Operator').map do |operator|
        { name: operator.content, stif_id: operator.attribute('id').to_s }
      end.to_a
    end


    class << self
      attr_accessor :timeout, :format, :base_url
    end
  end
end