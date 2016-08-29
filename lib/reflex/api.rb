module Reflex
  class API
    DEFAULT_TIMEOUT  = 30
    DEFAULT_FORMAT   = 'xml'
    DEFAULT_BASE_URL = "https://reflex.stif.info/ws/reflex/V1/service=getData"

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
        open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE, :read_timeout => @timeout)
      rescue Exception => e
        raise Reflex::ReflexError, "#{e.message} for request : #{url}."
      end
    end

    def parse_response zipfile
      begin
        file   = Zip::File.open(zipfile).first.get_input_stream.read
        reader = Nokogiri::XML::Reader(file)
      rescue Exception => e
        raise Reflex::ReflexError, e.message
      end
    end

    def process method
      zipfile    = self.api_request(method: method)
      reader     = self.parse_response zipfile

      stop_places          = {}
      stop_place_entrances = {}
      quays                = {}
      reader.each do |node|
        next unless node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
        case node.name
          when "StopPlace"         then stop_places[node.attribute('id')] = Reflex::StopPlaceNodeHandler.new(Nokogiri::XML(node.outer_xml)).process
          when "StopPlaceEntrance" then stop_place_entrances[node.attribute('id')] = Reflex::StopPlaceEntranceNodeHandler.new(Nokogiri::XML(node.outer_xml)).process
          when "Quay"              then quays[node.attribute('id')] = Reflex::QuayNodeHandler.new(Nokogiri::XML(node.outer_xml)).process
        end
      end
      {
        :StopPlace => stop_places,
        :StopPlaceEntrance => stop_place_entrances,
        :Quay => quays
      }
    end

    class << self
      attr_accessor :timeout, :format, :base_url
    end
  end
end
