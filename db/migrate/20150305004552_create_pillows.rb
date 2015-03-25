class CreatePillows < ActiveRecord::Migration
  def change
    create_table :pillows do |t|
      t.string  :zid
      t.string  :state
      t.string  :region
      t.string  :price, :default => "0"
      t.string  :lat
      t.string  :long
      t.timestamps null: false
    end
  end
end
