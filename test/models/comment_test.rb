# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id           :integer          not null, primary key
#  blog_id      :integer          not null
#  user_id      :integer          not null
#  document     :text             not null
#  published_dt :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
