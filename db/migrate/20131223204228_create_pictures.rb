class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :user
      t.references :report
      t.string :file

      t.timestamps
    end
    add_index :pictures, :user_id
    add_index :pictures, :report_id
  end
end
