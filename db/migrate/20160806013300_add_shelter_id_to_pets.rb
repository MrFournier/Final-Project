class AddShelterIdToPets < ActiveRecord::Migration[5.0]
  def change
    add_column :pets, :shelterId, :integer
  end
end
