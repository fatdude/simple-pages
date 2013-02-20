class AddCssAndJsToPages < ActiveRecord::Migration
  def change
    add_column :pages, :css, :text
    add_column :pages, :js, :text
  end
end
