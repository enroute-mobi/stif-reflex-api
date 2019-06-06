module Reflex
  class StopPlaceNodeHandler < Nokogiri::XML::SAX::Document
    def start_document
      @stop_place           = {}
      @text_stack           = []
      @lamber               = LamberWilson.new
    end

    def end_document
      @stop_place['type'] = 'StopPlace'
      @stop_place['gml:pos'] = @lamber.to_longlat(@stop_place['gml:pos'])
      API.stop_places << @stop_place
    end

    def start_element(name, attrs = [])
      @stop_place           = Hash[attrs]        if name == 'StopPlace'
      @stop_place['parent'] = Hash[attrs]['ref'] if name == 'ParentSiteRef'
    end

    def characters(string)
      string = string.gsub("\n", '').strip
      @text_stack << string unless string.empty?
    end

    def end_element(name)
      string = @text_stack.join
      @text_stack = []
      return if string.empty?

      @stop_place[name] = @stop_place[name].to_s + string
    end
  end
end
