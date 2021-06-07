class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :body
      t.references :user
      t.references :event
      t.timestamps
    end
  end
end
