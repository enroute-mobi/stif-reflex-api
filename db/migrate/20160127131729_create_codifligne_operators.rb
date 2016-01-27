class CreateCodifligneOperators < ActiveRecord::Migration
  def change
    create_table :codifligne_operators do |t|
      t.string :stif_id
      t.string :name

      t.timestamps null: false
    end
  end
end
