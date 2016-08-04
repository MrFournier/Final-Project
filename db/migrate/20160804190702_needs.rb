class Needs < ActiveRecord::Migration[5.0]
  def change
    create_table :needs do |t|
      t.references :pet
      t.integer :need_description
      t.integer :status, default: 100

      t.timestamps
    end
  end
end
