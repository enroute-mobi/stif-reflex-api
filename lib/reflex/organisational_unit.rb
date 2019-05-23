module Reflex
  class OrganisationalUnitNodeHandler < Nokogiri::XML::SAX::Document
    def start_document
      @organisational_unit = {}
      @text_stack = []
    end

    def end_document
      API.organisational_units << @organisational_unit
    end

    def start_element(name, attrs = [])
      @organisational_unit = Hash[attrs] if name == 'OrganisationalUnit'
      @organisational_unit['type_of_organisation'] = Hash[attrs]['ref'] if name == 'TypeOfOrganisationPartRef'
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
        @organisational_unit['name'] = string
      end
    end
  end
end
