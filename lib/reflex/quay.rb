module Reflex
  class QuayNodeHandler < Nokogiri::XML::SAX::Document
    def start_document
      @quay          = {}
      @text_stack    = []
      @is_destination = false
      @destinations  = []
      @previous_node = nil
      @lamber        = LamberWilson.new
    end

    def end_document
      @quay['type']    = 'Quay'
      @quay['gml:pos'] = @lamber.to_longlat(@quay['gml:pos'])
      @quay['destinations'] = @destinations
      @quay.delete_if { |k, v| v.nil? }
      API.quays << @quay
    end

    def start_element(name, attrs = [])
      @quay           = Hash[attrs]        if name == 'Quay'
      @quay['parent'] = Hash[attrs]['ref'] if name == 'ParentZoneRef'

      if name == 'TariffZoneRef'
        @quay['tariff_zones'] ||= []
        @quay['tariff_zones'] << Hash[attrs]['ref']
      elsif name == 'DestinationDisplayView'
        @is_destination = true
        @destinations << Hash[attrs]
      end
    end

    def end_element(name)
      @is_destination = false if name == 'DestinationDisplayView'

      string = @text_stack.join
      @text_stack = []
      return if string.empty?

      if @previous_node == 'Key' && name == 'Value'
        return @quay[@quay.keys.last] = string
      end

      if name == 'Key'
        @previous_node = name
        @quay[string] = nil
      else
        if @is_destination
          @destinations.last[name] = @destinations.last[name].to_s + string
        else
          @quay[name] = @quay[name].to_s + string
        end
      end
    end

    def characters(string)
      string = string.gsub("\n", '').strip
      @text_stack << string unless string.empty?
    end
  end
end
