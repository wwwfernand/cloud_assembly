# frozen_string_literal: true

class CreateUserImages < ActiveRecord::Migration[7.1]
  def change
    create_table :user_images, id: :uuid, default: 'gen_random_uuid()', force: :cascade do |t|
      t.belongs_to  :user, type: :uuid
      t.jsonb       :image_data, null: false

      t.timestamps
    end
    add_index :user_images, :image_data, using: :gin
  end
end
