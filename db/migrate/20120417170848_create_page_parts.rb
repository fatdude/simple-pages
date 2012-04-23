class CreatePageParts < ActiveRecord::Migration
  def change
    create_table :page_parts do |t|
      t.string :name
      t.text :content
      t.references :page

      t.timestamps
    end
  end
end
