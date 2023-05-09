class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills, id: false, primary_key: :id do |t|
      t.string :id
      t.string :title
      t.string :short_title
      t.string :sponsor_id
      t.string :congressdotgov_url
      t.string :govtrack_url
      t.boolean :active
      t.string :enacted
      t.string :primary_subject
      t.string :summary_short
      t.string :latest_major_action
      t.timestamps
    end
  end
end
