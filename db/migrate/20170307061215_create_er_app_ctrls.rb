class CreateErAppCtrls < ActiveRecord::Migration[5.0]
  def change
    create_table :er_app_ctrls do |t|
    	t.column "name" , :string
    	t.column "er_user_app_id" , :integer
      t.column "content" , :text
    	t.column "uic" , :string
      t.timestamps
    end
    add_index :er_app_ctrls , :uic , unique: true
    add_foreign_key :er_app_ctrls , :er_user_apps
  end
  def down
  	remove_index :er_app_ctrls , :uic
    remove_foreign_key :er_app_ctrls , :er_user_apps
  	drop_table :er_app_ctrls
  end
end
