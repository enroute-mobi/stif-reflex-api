module Reflex
  class StopPlaceNodeHandler < Nokogiri::XML::SAX::Document
    def start_document
      @stop_place = {}
      @text_stack = []
      @is_entrance = false
      @stop_place_entrances = []
    end

    def store_object_status
      @stop_place[@stop_place['Key']] = @stop_place['Value'] if @stop_place[@stop_place['Key']]
    end

    def end_document
      self.store_object_status
      @stop_place[:stop_place_entrances] = @stop_place_entrances
      API.stop_places << @stop_place
    end

    def start_element(name, attrs = [])
      @stop_place           = Hash[attrs]        if name == 'StopPlace'
      @stop_place['type']   = Hash[attrs]['ref'] if name == 'TypeOfPlaceRef'
      @stop_place['parent'] = Hash[attrs]['ref'] if name == 'ParentSiteRef'
      if name == 'StopPlaceEntrance'
        @is_entrance = true
        @stop_place_entrances << Hash[attrs]
      end
    end

    def end_element(name)
      if @is_entrance
        @stop_place_entrances.last[name] = @text_stack.pop if @text_stack.last
      else
        @stop_place[name] = @text_stack.pop if !@stop_place[name] && @text_stack.last
      end
      @is_entrance = false if name == 'StopPlaceEntrance'
    end

    def characters(string)
      data = string.gsub("\n", '').strip
      @text_stack << data unless data.empty?
    end
  end
end
