require 'rails_helper'

module Codifligne
  RSpec.describe Operator, :type => :model do
    describe 'validations' do
      it { should have_and_belong_to_many :lines }
      it { should validate_presence_of :name }
      it { should validate_presence_of :stif_id }
      it { should validate_uniqueness_of :stif_id }
    end
  end
end
