class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members, id: false, primary_key: :id do |t|
      t.string :id
      t.string :chamber
      t.integer :congress
      t.string :first_name
      t.string :last_name
      t.string :short_title
      t.string :party
      t.boolean :in_office
      t.timestamps
    end
  end
end
