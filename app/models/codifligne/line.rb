module Codifligne
  class Line < ActiveRecord::Base
    has_and_belongs_to_many :operators, :class_name => "Codifligne::Operator"

    validates :name, presence: true
    validates :stif_id, presence: true
    validates :short_name, presence: true
    validates :private_code, presence: true
  end
end
