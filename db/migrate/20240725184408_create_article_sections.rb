# frozen_string_literal: true

class CreateArticleSections < ActiveRecord::Migration[7.1]
  def change
    create_table :article_sections, id: :uuid, default: 'gen_random_uuid()', force: :cascade do |t|
      t.belongs_to  :article, type: :uuid
      t.text        :html_body
      t.integer     :status, default: 0, null: false

      t.timestamps
    end
  end
end
