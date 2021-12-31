class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :user
      t.references :problem
      t.references :solution

      t.timestamps
      t.index [:user_id, :problem_id], unique: true
      t.index [:user_id, :solution_id], unique: true
    end
  end
end
