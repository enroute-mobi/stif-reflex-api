require 'rails_helper'

module Codifligne
  RSpec.describe Line, :type => :model do
    describe 'validations' do
      it { should have_and_belong_to_many :operators }
      it { should validate_presence_of :name }
      it { should validate_presence_of :stif_id }
      it { should validate_uniqueness_of :stif_id }
      it { should validate_presence_of :short_name }
      it { should validate_presence_of :private_code }
    end
  end
end
