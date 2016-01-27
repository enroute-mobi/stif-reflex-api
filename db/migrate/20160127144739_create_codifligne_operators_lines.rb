class CreateCodifligneOperatorsLines < ActiveRecord::Migration
  def change
    create_table :codifligne_lines_operators do |t|
      t.belongs_to :operator, index: true
      t.belongs_to :line, index: true
    end
  end
end
