class CreateMyRestaurantApp < ActiveRecord::Migration[4.2]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.text :pic_url
      t.float :price
      t.text :description
    end
    create_table :orders do |t|
      t.integer :num_of_customer
      t.string :orders
      t.boolean :is_served
      t.boolean :is_paid
    end
  end
end
