class CreateSplitTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :split_types do |t|
      t.string :type_name
      t.text :description

      t.timestamps
    end
  end
end
