# frozen_string_literal: true

# == Schema Information
#
# Table name: articles
#
#  id         :uuid             not null, primary key
#  image_link :string
#  publish_at :datetime
#  rank       :integer          default(0)
#  status     :integer          default("draft"), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
class Article < ApplicationRecord
  include UserOwned
  Gutentag::ActiveRecord.call self

  belongs_to :user, inverse_of: :articles
  has_one :draft_section, lambda {
                            where(status: :draft)
                          }, class_name: 'ArticleSection', dependent: :destroy, autosave: true,
                             inverse_of: :article
  has_one :publish_section, -> { where(status: :publish) }, class_name: 'ArticleSection', dependent: :destroy,
                                                            inverse_of: :article

  accepts_nested_attributes_for :draft_section, update_only: true

  scope :public_view, lambda {
    where(status: %i[published revise])
      .where('publish_at <= ?', Time.zone.now)
  }

  scope :with_author, -> { includes(:user) }
  scope :with_body, -> { includes(:publish_section) }
  scope :popular, -> { order(rank: :desc) }

  TAG_COUNT_MAX = 6

  enum status: {
    draft: 0,
    published: 1,
    revise: 2
  }

  STATES = {
    draft: :draft,
    publish_now: :publish_now,
    publish_later: :publish_later
  }.freeze

  before_validation :new_or_redraft,      on: :draft
  before_validation :prepare_to_publish,  on: %i[publish_now publish_later]

  validate    :tag_count
  validates   :title, presence: true
  validates   :image_link, http_url: true, allow_blank: true

  with_options on: %i[publish_now publish_later] do
    validates :image_link, :title, :publish_at, :publish_section, presence: true
    validate :valid_section_content
  end

  with_options on: :publish_later do
    validate :future_publish_at
  end

  def public?
    (published? || revise?) && publish_at.past?
  end

  def future_publish?
    published? && publish_at.future?
  end

  def tag_list
    tag_names.join(', ')
  end

  def tag_list=(names)
    self.tag_names = names.gsub(/,/, ' ').gsub(/[^a-z0-9 ]/, '').gsub(/ +/, ' ').strip.downcase.split(' ')
  end

  private

  def tag_count
    return if tag_names.blank?
    return if tag_names.count <= TAG_COUNT_MAX

    errors.add(:tags, "words limit is #{TAG_COUNT_MAX}")
  end

  def future_publish_at
    return if publish_at.blank? || publish_at.future?

    errors.add(:publish_at, 'must be a future date')
  end

  def valid_section_content
    # manual check since validates_associated does not accept context
    return if publish_section.blank? || publish_section.html_body.present?

    errors.add(:publish_section, :blank)
  end

  def new_or_redraft
    return if draft?

    self.status = :revise
  end

  def prepare_to_publish
    return if published?

    self.status = :published
    self.publish_at = Time.zone.now if publish_at.blank?
    move_draft_to_publish_section
  end

  def move_draft_to_publish_section
    build_publish_section unless publish_section
    publish_section.html_body = draft_section.html_body
  end
end
