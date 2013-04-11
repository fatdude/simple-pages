class AddLinkableToPages < ActiveRecord::Migration
  def change
    add_column :pages, :linkable, :boolean, default: true
  end
end
