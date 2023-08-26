class CreateLocalAuthority < ActiveRecord::Migration[6.1]
  def change
    create_table :local_authorities do |t|
      t.string :name

      t.timestamps
    end
  end
end
