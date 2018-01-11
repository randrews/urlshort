class CreateLink < ActiveRecord::Migration[5.1]
  def change
    create_table :links do |t|
      t.text :url # URLs can be long. Especially ones you want to shorten.
      t.string :code
    end

    add_index :links, :url
    add_index :links, :code
  end
end
