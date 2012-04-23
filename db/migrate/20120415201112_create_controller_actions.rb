class CreateControllerActions < ActiveRecord::Migration
  def change
    create_table :controller_actions do |t|
      t.string :controller
      t.string :action
      t.references :page

      t.timestamps
    end
    add_index :controller_actions, [:page_id, :controller, :action]
  end
end
