class CreateInventions < ActiveRecord::Migration[5.2]
  def change
    create_table :inventions do |t|
      t.string :title, limit: 255, null: false
      t.text :description, null: false
      t.string :username, limit: 255
      t.string :email, limit: 255

      t.timestamps
    end
  end
end
