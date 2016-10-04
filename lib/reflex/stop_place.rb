module Reflex
  class StopPlace
    attr_accessor *%i[
      id
      version
      object_status
      created
      changed
      name
      type_of_place
      type_of_place_ref
      city
      postal_code
      area_type
      parent_site_ref
      parent_site_ref_version
      entrances
      quays
      xml
    ]

    def initialize params
      params.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end

  class StopPlaceNodeHandler < Struct.new(:node)
    def process
      node.remove_namespaces!
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
      params[:area_type]         = 'StopPlace'

      node.css('KeyValue').each do |entry|
        params[entry.at_css('Key').content.downcase] = entry.at_css('Value').content
      end
      params[:quays] = node.css('QuayRef').map do |quay|
        {
          ref: quay.attribute('ref').to_s,
          version: quay.attribute('version').to_s
        }
      end
      params[:entrances] = node.css('StopPlaceEntrance').map do |entrance|
        Reflex::StopPlaceEntranceNodeHandler.new(entrance).process
      end
      if node.at_css('ParentSiteRef')
        params[:parent_site_ref]         = node.at_css('ParentSiteRef').attribute('ref').to_s
        params[:parent_site_ref_version] = node.at_css('ParentSiteRef').attribute('version').to_s
      end

      StopPlace.new params
    end
  end
end
