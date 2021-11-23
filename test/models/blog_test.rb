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
require 'test_helper'

class BlogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
