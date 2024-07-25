# frozen_string_literal: true

class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles, id: :uuid, default: 'gen_random_uuid()', force: :cascade do |t|
      t.belongs_to  :user, type: :uuid
      t.string      :title, null: false
      t.datetime    :publish_at
      t.integer     :status, null: false, default: 0
      t.string      :image_link
      t.integer     :rank, default: 0

      t.timestamps
    end
  end
end
