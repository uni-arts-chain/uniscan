# == Schema Information
#
# Table name: tokens
#
#  id                  :bigint           not null, primary key
#  token_id_on_chain   :string(255)
#  collection_id       :integer
#  unique              :boolean          default(TRUE)
#  supply              :decimal(65, )    default(1)
#  owner_id            :integer
#  name                :string(255)
#  description         :text(65535)
#  image_uri           :string(255)
#  token_uri           :text(65535)
#  token_uri_err       :text(65535)
#  ipfs                :boolean          default(FALSE)
#  transfers_count     :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  holders_count       :integer          default(0)
#  token_uri_processed :boolean          default(FALSE)
#  transfers_count_24h :integer          default(0)
#  transfers_count_7d  :integer          default(0)
#  last_transfer_time  :datetime
#
require "test_helper"

class TokenTest < ActiveSupport::TestCase
  test "should not save token without token_id_on_chain" do
    token = Token.new
    assert_not token.save, "Saved the token without a token_id_on_chain"
  end

  test "should fill infos by processing token uri" do
    token = tokens[0]

    assert_nil token.name
    assert_nil token.description
    assert_nil token.image_uri
    assert_equal token.token_uri_processed, false

    token.process_token_uri

    assert_not_nil token.name
    assert_not_nil token.description
    assert_not_nil token.image_uri
    assert_equal token.token_uri_processed, true
  end

  test "can be clean" do
    token = tokens[0]
    token.update(
      name: "hello",
      description: "world",
      image_uri: "https://hello.world",
      token_uri_processed: true
    )

    assert_not_nil token.name
    assert_not_nil token.description
    assert_not_nil token.image_uri

    token.clean()

    assert_nil token.name
    assert_nil token.description
    assert_nil token.image_uri
  end
end
