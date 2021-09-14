# == Schema Information
#
# Table name: blockchains
#
#  id                   :bigint           not null, primary key
#  name                 :string(255)
#  testnet              :boolean          default(FALSE)
#  explorer_token_url   :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  explorer_address_url :string(255)
#
class Blockchain < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
