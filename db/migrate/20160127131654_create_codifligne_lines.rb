class CreateCodifligneLines < ActiveRecord::Migration
  def change
    create_table :codifligne_lines do |t|
      t.string :stif_id
      t.string :name
      t.string :short_name
      t.string :transport_mode
      t.string :private_code
      t.string :status

      t.timestamps null: false
    end

    add_index :codifligne_lines, [:transport_mode, :status]
  end
end
