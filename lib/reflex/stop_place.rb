module Reflex
  class StopPlace
    attr_accessor :id, :version, :name, :type_of_place, :city, :postal_code

    def initialize params
      params.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end

  class StopPlaceNodeHandler < Struct.new(:node)
    def process
      params = {}
      [:id, :version, :created, :changed].each do |attr|
        params[attr] = node.css('StopPlace').attribute(attr.to_s).to_s
      end

      params[:name]              = node.at_css('Name').content
      params[:city]              = node.at_css('Town').content
      params[:postal_code]       = node.at_css('PostalRegion').content
      params[:type_of_place_ref] = node.at_css('TypeOfPlaceRef').attribute('ref').to_s
      params[:type_of_place]     = node.at_css('StopPlaceType').content
      params[:xml]               = node.to_s

      node.css('KeyValue').each do |entry|
        params[entry.at_css('Key').content.downcase] = entry.at_css('Value').content
      end

      if node.at_css('ParentSiteRef')
        params[:parent_site_ref]         = node.at_css('ParentSiteRef').attribute('ref').to_s
        params[:parent_site_ref_version] = node.at_css('ParentSiteRef').attribute('version').to_s
      end

      StopPlace.new params
    end
  end
end
