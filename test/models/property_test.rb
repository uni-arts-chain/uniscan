# == Schema Information
#
# Table name: properties
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  value      :text(65535)
#  token_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class PropertyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
