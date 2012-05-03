class AddFilterToPageParts < ActiveRecord::Migration
  def change
    add_column :page_parts, :filter, :integer, default: 0
  end
end
