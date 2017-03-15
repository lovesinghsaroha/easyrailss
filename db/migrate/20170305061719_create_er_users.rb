class CreateErUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :er_users do |t|
    	t.column "email", :string 
    	t.column "name" , :string
    	t.column "password_digest" , :string
    	t.column "app_lm" , :integer , default: 1
      t.timestamps
    end
  end
  def down
  	drop_table :er_users
  end
end
