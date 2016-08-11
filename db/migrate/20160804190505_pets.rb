class Pets < ActiveRecord::Migration[5.0]
  def change
    create_table :pets do |t|
      t.references :user
      t.string :name
      t.string :breed
      t.string :age
      t.string :sex
      t.boolean :adopted, default: false
      t.string :avatar
      t.string :unique_api_id
      t.integer :shelterId
      t.string :pressing_need

      t.timestamps
    end
  end
end
