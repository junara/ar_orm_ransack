# frozen_string_literal: true

# == Schema Information
#
# Table name: blogs
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  published_dt :date
#  status       :integer          not null
#  document     :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Blog < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  enum status: {
    edited: 1,
    published: 2,
    canceled: 99
  }
end
