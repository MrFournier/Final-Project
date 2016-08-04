class Users < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.references :pet
      t.string :username
      t.string :password_digest
      t.integer :reputation, default: 0

      t.timestamps
    end
  end
end
