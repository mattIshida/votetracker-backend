class CreatePositions < ActiveRecord::Migration[7.0]
  def change
    create_table :positions do |t|
      t.string :member_id
      t.string :vote_id
      t.string :vote_position
      t.string :party
      t.timestamps
    end
  end
end
