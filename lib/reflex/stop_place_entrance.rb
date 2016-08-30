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
    ]

    def initialize params
      params.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end

  class StopPlaceEntranceNodeHandler < Struct.new(:node)
    def process
      node.remove_namespaces!
      params = {
        :id          => node.css('StopPlaceEntrance').attribute('id').to_s,
        :version     => node.css('StopPlaceEntrance').attribute('version').to_s,
        :name        => node.at_css('Name').content,
        :city        => node.at_css('PostalAddress Town').content,
        :postal_code => node.at_css('PostalAddress PostalRegion').content,
        :is_exit     => node.at_css('IsExit').content,
        :is_entry    => node.at_css('IsEntry').content,
        :location    => node.at_css('pos').content,
        :area_type   => 'StopPlaceEntrance'
      }
      StopPlaceEntrance.new params
    end
  end
end
