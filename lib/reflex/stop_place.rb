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
      @stop_place['type'] = 'StopPlace'
      @stop_place[:stop_place_entrances] = @stop_place_entrances
      API.stop_places << @stop_place
    end

    def start_element(name, attrs = [])
      @stop_place           = Hash[attrs]        if name == 'StopPlace'
      @stop_place['parent'] = Hash[attrs]['ref'] if name == 'ParentSiteRef'
      @stop_place[name]     = Hash[attrs]['ref'] if name == 'TypeOfPlaceRef'

      @current_node = name
      if name == 'QuayRef'
        @stop_place['quays'] ||= []
        @stop_place['quays'] << Hash[attrs]['ref']
      end
      if name == 'StopPlaceEntrance'
        @is_entrance = true
        @stop_place_entrances << Hash[attrs]
      end
    end

    def characters(string)
      string = string.gsub("\n", '').strip
      return if string.empty?

      if @is_entrance
        @stop_place_entrances.last[@current_node] = @stop_place_entrances.last[@current_node].to_s + string
      else
        @stop_place[@current_node] = @stop_place[@current_node].to_s + string
      end
    end

    def end_element(name)
      @is_entrance = false if name == 'StopPlaceEntrance'
    end
  end
end
