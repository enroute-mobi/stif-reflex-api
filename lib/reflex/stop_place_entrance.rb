module Reflex
  class StopPlaceEntrance
    attr_accessor *%i[
      id
      name
      version
      city
      postal_code
      is_entry
      is_exit
      location
      area_type
      access_type
    ]

    def initialize params
      params.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end

  class StopPlaceEntranceNodeHandler < Struct.new(:node)


    def access_type params
      if params[:is_entry] == 'true' && params[:is_exit] == 'true'
        'in_out'
      elsif params[:is_entry] == 'true'
        'in'
      elsif params[:is_exit] == 'true'
        'out'
      end
    end

    def process
      params = {}
      [:id, :version].each do |attr|
        params[attr] = node.attribute(attr.to_s).to_s
      end

      params[:name]        = node.at_css('Name').content
      params[:city]        = node.at_css('PostalAddress Town').content
      params[:postal_code] = node.at_css('PostalAddress PostalRegion').content
      params[:is_exit]     = node.at_css('IsExit').content
      params[:is_entry]    = node.at_css('IsEntry').content
      params[:location]    = node.at_css('pos').content
      params[:area_type]   = 'StopPlaceEntrance'
      params[:access_type] = self.access_type params

      StopPlaceEntrance.new params
    end
  end
end
