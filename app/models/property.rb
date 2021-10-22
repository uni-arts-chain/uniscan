# Records all infos from token's metadata except the name, symbol, and image.
#
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
class Property < ApplicationRecord
  belongs_to :token
end
