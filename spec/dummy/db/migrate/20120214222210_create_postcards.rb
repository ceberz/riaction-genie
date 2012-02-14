class CreatePostcards < ActiveRecord::Migration
  def self.change
    create_table :postcards do |t|
      t.string :content
      t.belongs_to :user

      t.timestamps
    end
  end
end
