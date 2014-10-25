class CreateUpyuns < ActiveRecord::Migration
  def change
    create_table :upyuns do |t|
      t.string :url, null:false
      t.integer :width, null:false, default:0
      t.integer :height, null:false, default:0
      t.integer :state, null:false, default:1
      t.integer :source, null:false, default:0

      t.timestamps
    end
  end
end