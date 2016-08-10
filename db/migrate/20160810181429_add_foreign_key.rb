class AddForeignKey < ActiveRecord::Migration[5.0]
  def change
    add_reference :pets, :users
  end
end
