module Reflex
  class StopArea
    attr_accessor :stif_id, :version, :name, :description, :objectstatus, :type_of_place

    def initialize params
      params.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

  end
end