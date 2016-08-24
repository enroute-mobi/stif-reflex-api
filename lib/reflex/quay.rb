module Reflex
  class Quay
    attr_accessor :id, :version, :name, :city, :postal_code, :location, :mobility_impaired_access

    def initialize params
      params.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end

  class QuayNodeHandler < Struct.new(:node)
    def process
      node.remove_namespaces!
      params = {}
      [:id, :version, :created, :changed].each do |attr|
        params[attr] = node.css('Quay').attribute(attr.to_s).to_s
      end
      params[:name]                     = node.at_css('Name').content
      params[:city]                     = node.at_css('Town').content
      params[:postal_code]              = node.at_css('PostalRegion').content
      params[:mobility_impaired_access] = node.at_css('MobilityImpairedAccess').content
      params[:xml]                      = node.to_s

      node.css('KeyValue').each do |entry|
        params[entry.at_css('Key').content.downcase] = entry.at_css('Value').content
      end

      Quay.new params
    end
  end
end
