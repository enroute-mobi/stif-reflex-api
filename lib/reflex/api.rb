module Reflex
  class API
    DEFAULT_TIMEOUT  = 30
    DEFAULT_FORMAT   = 'xml'
    DEFAULT_BASE_URL = "https://195.46.215.128/ws/reflex/V1/service=getData"
    @quays       = []
    @stop_places = []
    @operators = []

    attr_accessor :timeout, :format, :base_url

    def initialize(timeout: nil, format: nil)
      @timeout  = timeout || self.class.timeout || DEFAULT_TIMEOUT
      @format   = format || self.class.format || DEFAULT_FORMAT
      @base_url = self.class.base_url || DEFAULT_BASE_URL
    end

    def build_url(params = {})
      default = {
        :idRefa            => 0,
        :format            => self.format
      }
      query = default.merge(params).map{|k, v| [k,v].join('=') }.to_a.join('&')
      url   = URI.escape "#{self.base_url}/?#{query}"
    end

    def api_request(params = {})
      raise Reflex::ReflexError, "No method specified" if params[:method].nil?
      url = build_url(params)
      begin
        result = open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE, :read_timeout => @timeout)
        return result unless result.is_a? StringIO

        tmpfile = Tempfile.new("file")
        tmpfile.binmode
        tmpfile.write(result.read)
        tmpfile.close
        tmpfile
      rescue Exception => e
        raise Reflex::ReflexError, "#{e.message} for request : #{url}."
      end
    end

    def parse_response file
      begin
        reader = Nokogiri::XML::Reader(file)
      rescue Exception => e
        raise Reflex::ReflexError, e.message
      end
    end

    def reset_processed
      self.class.stop_places = []
      self.class.quays = []
      self.class.operators = []
    end

    def process method
      self.process_with_params(method: method)
    end

    def process_with_params params
      apifile = self.api_request params

      type = FileMagic.new(:mime_type).file(apifile.path)
      if %w{text/xml application/xml}.include? type
        file = File.open(apifile.path, "r")
        reader =  self.parse_response(file)
      else
        reader  = self.parse_response(Zip::File.open(apifile.path).first.get_input_stream.read)
      end

      reader.each do |node|
        next unless node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
        next unless ['StopPlace', 'Quay', 'Operator'].include?(node.name)

        xml = node.outer_xml
        if node.name == 'StopPlace'
          Nokogiri::XML::SAX::Parser.new(StopPlaceNodeHandler.new).parse(xml)
          self.class.stop_places.last[:xml] = xml
        end

        if node.name == 'Quay'
          Nokogiri::XML::SAX::Parser.new(QuayNodeHandler.new).parse(xml)
          self.class.quays.last[:xml] = xml
        end

        if node.name == 'Operator'
          Nokogiri::XML::SAX::Parser.new(OperatorNodeHandler.new).parse(xml)
          self.class.operators.last[:xml] = xml
        end
      end
      results = {
        :StopPlace => self.class.stop_places,
        :Quay      => self.class.quays,
        :Operator  => self.class.operators
      }
      self.reset_processed
      results
    ensure
      file.close unless file.nil?
    end

    class << self
      attr_accessor :timeout, :format, :base_url, :quays, :stop_places, :operators
    end
  end
end
