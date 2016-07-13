class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :response_type
      t.string :response_email
      t.string :response_phone
      t.string :response_name

      t.timestamps null: false
    end
  end
end
