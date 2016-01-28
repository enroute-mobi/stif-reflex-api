module Codifligne
  class Operator < ActiveRecord::Base
    has_and_belongs_to_many :lines, :class_name => "Codifligne::Line"

    validates :name, presence: true
    validates :stif_id, presence: true, uniqueness: true
  end
end
