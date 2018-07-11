module Reflex
  class OperatorNodeHandler < Nokogiri::XML::SAX::Document
    def start_document
      @operator = {}
      @text_stack = []
    end

    def end_document
      API.operators << @operator
    end

    def start_element(name, attrs = [])
      @operator = Hash[attrs] if name == 'Operator'
    end

    def characters(string)
      string = string.gsub("\n", '').strip
      @text_stack << string unless string.empty?
    end

    def end_element(name)
      string = @text_stack.join
      @text_stack = []
      return if string.empty?

      if name == 'Name'
        @operator['name'] = string
      end
    end
  end
end
