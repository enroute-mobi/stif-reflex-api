module Codifligne
  class Operator
    attr_accessor :name, :stif_id

    def initialize params
      params.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

  end
end