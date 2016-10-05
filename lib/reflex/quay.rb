module Reflex
  class QuayNodeHandler < Nokogiri::XML::SAX::Document
    def start_document
      @quay = {}
      @text_stack = []
    end

    def end_document
      # OBJECT_STATUS
      @quay[@quay['Key']] = @quay['Value']
      API.quays << @quay
    end

    def start_element(name, attrs = [])
      @quay = Hash[attrs] if name == 'Quay'
    end

    def end_element(name)
      @quay[name] = @text_stack.pop if @text_stack.last && !@quay[name]
    end

    def characters(string)
      data = string.gsub("\n", '').strip
      @text_stack << data unless data.empty?
    end
  end
end
