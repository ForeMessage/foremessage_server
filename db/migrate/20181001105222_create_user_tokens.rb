class CreateUserTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :user_tokens do |t|
      t.references :user
      t.string :access_token
      t.string :device_token

      t.timestamps
    end
  end
end
