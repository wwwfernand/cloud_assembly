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
require 'rails_helper'

RSpec.describe ArticleSection, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
