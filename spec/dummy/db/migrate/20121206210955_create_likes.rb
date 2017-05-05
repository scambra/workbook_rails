class CreateLikes < (Rails.version < '5.1' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0])
  def change
    create_table :likes do |t|
      t.string :name
      t.integer :user_id

      t.timestamps null: true
    end
  end
end
