class RemoveForeignKey < ActiveRecord::Migration[5.0]
  def change
    remove_reference :pets, :users, index: true, foreign_key: true
    remove_reference :users, :pet, index: true, foreign_key: true
  end
end
