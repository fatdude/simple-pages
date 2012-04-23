class AddSortedAtToPages < ActiveRecord::Migration
  def change
    add_column :pages, :sorted_at, :datetime
  end
end
