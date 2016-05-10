class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.integer :gb_id
      t.string :title
      t.string :release_year
      t.string :imdb_link
      t.string :rating
      t.string :small_img
      t.string :med_img
      t.string :large_img

      t.timestamps null: false
    end
  end
end
