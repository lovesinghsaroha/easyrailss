class CreateErCtrlViews < ActiveRecord::Migration[5.0]
  def change
    create_table :er_ctrl_views do |t|
      t.column "name" , :string
    	t.column "er_user_app_id" , :integer
      t.column "content" , :text
      t.column "uic" , :string
      t.column "ctrl_n" , :string	
      t.timestamps
    end
    add_index :er_ctrl_views , :uic , unique: true
    add_foreign_key :er_ctrl_views , :er_user_apps
  end
  def down
  	remove_index :er_ctrl_views , :uic
    remove_foreign_key :er_ctrl_views , :er_user_apps
  	drop_table :er_ctrl_views
  end
end
