class AddPositionToPages < ActiveRecord::Migration
  def change
    add_column :pages, :position, :integer
    remove_column :pages, :sorted_at
  end
end
