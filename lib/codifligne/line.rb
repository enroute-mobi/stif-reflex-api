module Codifligne
  class Line
    attr_accessor :name, :short_name, :transport_mode, :operator_code, :stif_id, :status, :accessibility, :transport_submode

    def initialize params
      params.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

  end
end