class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes, id: false, primary_key: :id do |t|
      t.string :id
      t.integer :congress
      t.string :chamber
      t.integer :session
      t.integer :roll_call
      t.string :vote_uri
      t.string :votable_type, polymorphic: true
      t.string :votable_id, polymorphic: true
      t.string :question
      t.string :question_text
      t.string :description
      t.string :vote_type
      t.string :date
      t.string :year
      t.string :month
      t.string :time
      t.string :result
      t.timestamps
    end
  end
end
