# == Schema Information
#
# Table name: tokens
#
#  id                :bigint           not null, primary key
#  token_id_on_chain :string(255)
#  collection_id     :integer
#  unique            :boolean          default(TRUE)
#  supply            :integer          default(1)
#  creator_id        :integer
#  owner_id          :integer
#  name              :string(255)
#  description       :string(255)
#  image             :string(255)
#  token_uri         :text(65535)
#  is_permanent      :boolean
#  explorer_url      :string(255)
#  transfers_count   :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  holders_count     :integer          default(0)
#
class Token < ApplicationRecord
  belongs_to :collection
  # TODO: a background to update creator
  # belongs_to :creator, class_name: "Account"
  belongs_to :owner, class_name: "Account"

  validates :token_id_on_chain, presence: true
end
