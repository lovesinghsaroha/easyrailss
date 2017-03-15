class CreateErAppMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :er_app_members do |t|
    	t.column "er_user_id" , :integer
    	t.column "er_user_app_id" , :integer
    	t.column "uic" , :string
    	t.column "owner" , :boolean , default: false
      t.timestamps
    end
    add_index :er_app_members , :uic , unique: true
    add_foreign_key :er_app_members , :er_users
    add_foreign_key :er_app_members , :er_user_apps 
  end
  def down
  	remove_index :er_app_members , :uic
  	remove_foreign_key :er_app_members , :er_users
  	remove_foreign_key :er_app_members , :er_user_apps
  	drop_table :er_app_members
  end
end
