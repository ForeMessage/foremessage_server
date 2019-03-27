class CreateReservationMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :reservation_messages do |t|
      t.string :sender
      t.string :receiver
      t.string :receiver_token
      t.text :message
      t.text :image
      t.datetime :send_at

      t.timestamps
    end
  end
end
