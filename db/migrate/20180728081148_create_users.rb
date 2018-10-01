class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :password_digest
      t.string :phone_number
      t.string :name
      t.datetime :birthday

      t.timestamps
    end

    add_index :users, :phone_number
  end
end
