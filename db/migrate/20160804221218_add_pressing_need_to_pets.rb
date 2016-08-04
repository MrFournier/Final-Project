class AddPressingNeedToPets < ActiveRecord::Migration[5.0]
  def change
    add_column :pets, :pressing_need, :string
  end
end
