class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :phone_number
      t.string :device_id
      t.string :name
      t.date :birthday

      t.timestamps
    end

    add_index :users, :phone_number
  end
end
