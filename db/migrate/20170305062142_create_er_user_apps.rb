class CreateErUserApps < ActiveRecord::Migration[5.0]
  def change
    create_table :er_user_apps do |t|
    	t.column "name" ,:string 
    	t.column "description" , :string
      t.column "rep_n" , :string
      t.column "routes_inf" , :text
      t.column "db_inf" , :text , default: "{}"
      t.timestamps
    end
    add_index :er_user_apps , :rep_n , unique: true
  end
  def down
    remove_index :er_user_apps , :rep_n
  	drop_table :er_user_apps
  end
end
