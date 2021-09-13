# == Schema Information
#
# Table name: tokens
#
#  id                :bigint           not null, primary key
#  token_id_on_chain :string(255)
#  collection_id     :integer
#  unique            :boolean          default(TRUE)
#  supply            :integer          default(1)
#  owner_id          :integer
#  name              :string(255)
#  description       :text(65535)
#  image             :string(255)
#  token_uri         :text(65535)
#  token_uri_err     :text(65535)
#  ipfs              :boolean          default(FALSE)
#  transfers_count   :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  holders_count     :integer          default(0)
#  token_uri_parsed  :boolean          default(FALSE)
#
require "test_helper"

class TokenTest < ActiveSupport::TestCase
  test "should not save token without token_id_on_chain" do
    token = Token.new
    assert_not token.save, "Saved the token without a token_id_on_chain"
  end
end
