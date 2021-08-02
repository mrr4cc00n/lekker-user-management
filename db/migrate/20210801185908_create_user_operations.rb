class CreateUserOperations < ActiveRecord::Migration[6.1]
  def change
    create_table :user_operations do |t|

      t.belongs_to :user
      t.string :user_modified, index: true, foreign_key: true
      t.integer :action
      t.timestamps
    end
  end
end
