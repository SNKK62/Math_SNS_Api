class CreateProblems < ActiveRecord::Migration[6.1]
  def change
    create_table :problems do |t|
      # t.binary :image_1
      # t.binary :image_2
      # t.binary :image_3
      t.text :description
      t.string :category
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :problems, [:user_id, :created_at]
  end
end
