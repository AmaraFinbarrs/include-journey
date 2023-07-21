class CreateUploads < ActiveRecord::Migration[6.1]
  def change
    create_table :uploads do |t|
      t.text :comment
      t.string :status, default: 'pending'
      t.string :approved_by
      t.datetime :approved_at
      t.references :user, null: false, foreign_key: true
      t.references :uploadable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
