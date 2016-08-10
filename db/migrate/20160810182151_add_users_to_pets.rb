class AddUsersToPets < ActiveRecord::Migration[5.0]
  def change
    add_reference :pets, :user, foreign_key: true
  end
end
