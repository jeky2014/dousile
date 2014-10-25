class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :source, null:false, default:0
      t.integer :state, null:false, default:0
      t.string :title, null:false
      t.text :content, null:false 
      t.integer :hitt, null:false, default:0 
      t.integer :hitm, null:false, default:0
      t.integer :sign, null:false, default:0
      t.boolean :haspic, null:false, default:0
      t.string :picpath
      t.string :tag
      t.datetime :pubtime, null:false
      
      t.timestamps
    end
  end
end