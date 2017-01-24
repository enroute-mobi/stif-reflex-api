module Reflex
  class QuayNodeHandler < Nokogiri::XML::SAX::Document
    def start_document
      @quay          = {}
      @text_stack    = []
      @previous_node = nil
    end

    def end_document
      @quay['type'] = 'Quay'
      @quay.delete_if { |k, v| v.nil? }
      API.quays << @quay
    end

    def start_element(name, attrs = [])
      @quay = Hash[attrs] if name == 'Quay'
      @current_node = name
    end

    def end_element(name)
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
        @quay[name] = @quay[name].to_s + string
      end
    end

    def characters(string)
      string = string.gsub("\n", '').strip
      @text_stack << string unless string.empty?
    end
  end
end
