class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :response_type
      t.string :response_email
      t.string :response_phone
      t.string :response_name
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
