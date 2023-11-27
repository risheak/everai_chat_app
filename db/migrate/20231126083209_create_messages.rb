class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.boolean :archived
      t.text :body
      t.integer :sent_by
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
