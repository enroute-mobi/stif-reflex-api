module Reflex
  class QuayNodeHandler < Nokogiri::XML::SAX::Document
    def start_document
      @quay = {}
      @text_stack = []
    end

    def end_document
      # OBJECT_STATUS
      @quay[@quay['Key']] = @quay['Value']
      @quay['type'] = 'Quay'
      API.quays << @quay
    end

    def start_element(name, attrs = [])
      @quay = Hash[attrs] if name == 'Quay'
      @current_node = name
    end

    def end_element(name)
      @quay[name] = @text_stack.pop if @text_stack.last && !@quay[name]
    end

    def characters(string)
      string = string.gsub("\n", '').strip
      @quay[@current_node] = @quay[@current_node].to_s + string unless string.empty?
    end
  end
end
