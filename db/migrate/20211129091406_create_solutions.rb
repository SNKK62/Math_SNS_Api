class CreateSolutions < ActiveRecord::Migration[6.1]
  def change
    create_table :solutions do |t|
      # t.binary :image_1
      # t.binary :image_2
      # t.binary :image_3
      t.text :description
      t.references :user, foreign_key: true
      t.references :problem, foreign_key: true

      t.timestamps
    end
    add_index :solutions,[:user_id, :created_at]
    add_index :solutions,[:problem_id, :created_at]
  end
end
