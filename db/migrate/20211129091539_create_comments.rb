class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      # t.binary :image
      t.text :text
      t.references :user, foreign_key: true
      t.references :problem, foreign_key: true
      t.references :solution, foreign_key: true
      

      t.timestamps
    end
    add_index :comments,[:user_id, :created_at]
    add_index :comments,[:problem_id, :created_at]
  end
end
