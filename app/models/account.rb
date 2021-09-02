# == Schema Information
#
# Table name: accounts
#
#  id            :bigint           not null, primary key
#  address       :string(255)
#  blockchain_id :integer
#  level         :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Account < ApplicationRecord
  validates :address, presence: true
  validates :blockchain_id, presence: true
end
