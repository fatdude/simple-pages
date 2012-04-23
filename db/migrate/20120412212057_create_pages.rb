class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :link
      t.string :url
      t.string :ancestry
      t.boolean :display_in_menu
      t.integer :status

      t.timestamps
    end

    add_index :pages, :ancestry
    add_index :pages, :url
  end
end
