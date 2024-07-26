# frozen_string_literal: true

# == Schema Information
#
# Table name: article_sections
#
#  id         :uuid             not null, primary key
#  html_body  :text
#  status     :integer          default("draft"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :uuid
#
# Indexes
#
#  index_article_sections_on_article_id  (article_id)
#
class ArticleSection < ApplicationRecord
  enum status: { draft: 0, publish: 1 }
end
