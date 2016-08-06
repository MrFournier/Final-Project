class AddShelterToPets < ActiveRecord::Migration[5.0]
  def change
    add_column :pets, :shelter, :string
  end
end
