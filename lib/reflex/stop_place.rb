module Reflex
  class StopPlaceNodeHandler < Nokogiri::XML::SAX::Document
    def start_document
      @stop_place           = {}
      @is_entrance          = false
      @stop_place_entrances = []
      @text_stack           = []
      @previous_node        = nil
      @lamber               = LamberWilson.new
    end

    def end_document
      @stop_place_entrances.map {|spe| spe['gml:pos'] = @lamber.to_longlat(spe['gml:pos']) }
      @stop_place['type'] = 'StopPlace'
      @stop_place[:stop_place_entrances] = @stop_place_entrances
      API.stop_places << @stop_place
    end

    def start_element(name, attrs = [])
      @stop_place           = Hash[attrs]        if name == 'StopPlace'
      @stop_place['parent'] = Hash[attrs]['ref'] if name == 'ParentSiteRef'
      @stop_place[name]     = Hash[attrs]['ref'] if name == 'TypeOfPlaceRef'

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
      @text_stack << string unless string.empty?
    end

    def end_element(name)
      @is_entrance = false if name == 'StopPlaceEntrance'

      string = @text_stack.join
      @text_stack = []
      return if string.empty?

      if @previous_node == 'Key' && name == 'Value'
        return @stop_place[@stop_place.keys.last] = string
      end

      if name == 'Key'
        @previous_node = name
        @stop_place[string] = nil
      else
        if @is_entrance
          @stop_place_entrances.last[name] = @stop_place_entrances.last[name].to_s + string
        else
          @stop_place[name] = @stop_place[name].to_s + string
        end
      end
    end
  end
end
