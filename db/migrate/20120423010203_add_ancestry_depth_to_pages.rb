class AddAncestryDepthToPages < ActiveRecord::Migration
  def change
    add_column :pages, :ancestry_depth, :integer, default: 0
  end
end
