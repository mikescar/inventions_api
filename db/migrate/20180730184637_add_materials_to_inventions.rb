class AddMaterialsToInventions < ActiveRecord::Migration[5.2]
  # Using up/down instead of a single `change` method is the safer & less lazy way to write migrations
  def up
    add_column :inventions, :materials, 'text[]', null: false, default: []
    add_index :inventions, :materials, using: :gin
  end

  def down
    remove_index :inventions, :materials
    remove_column :inventions, :materials
  end
end
