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
require 'mime/types'
class Token < ApplicationRecord

  belongs_to :collection
  has_many :properties
  has_many :token_ownerships, -> { where('balance > 0') }
  has_many :accounts, through: :token_ownerships

  has_one_attached :image

  validates :token_id_on_chain, presence: true

  delegate :blockchain, to: :collection
  delegate :nft_type, to: :collection

  scope :eligible, -> {
    where(
      "token_uri_processed=true and " + 
      "token_uri_err is null and " + 
      "TRIM(token_uri) != '' and " +
      "image_uri is not null and " + 
      "TRIM(image_uri) != ''"
    )
  }

  def historical_owners_count
    Transfer.where(token: self).distinct.count(:token_id)
  end

  def owner
    self.accounts[0]
  end

  def owners
    self.accounts
  end

  def broadcast
    broadcast_prepend_to('tokens') 

    broadcast_prepend_to("tokens:#{self.collection.blockchain_id}:_")
    broadcast_prepend_to("tokens:_:#{self.collection.nft_type_before_type_cast}")
    broadcast_prepend_to("tokens:#{self.collection.blockchain_id}:#{self.collection.nft_type_before_type_cast}")
  end

  def clean
    self.image.purge

    Property.where(token: self).delete_all

    self.update(
      name: nil,
      description: nil,
      image_uri: nil,

      token_uri_processed: false,
      token_uri_err: nil
    )
  end

  def process_token_uri
    data = get_token_uri_json

    name = data["name"]
    description = data["description"]
    image_uri = data["image"]

    raise "The `image_uri` is required" if image_uri.blank?

    raise "This nft is deprecated" if image_uri == 'https://mcp3d.com/api/image/deprecated'

    token_uri = self.token_uri&.strip
    is_ipfs = is_ipfs_uri?(token_uri) && is_ipfs_uri?(image_uri)

    # 1. attach image
    attach_image(image_uri)

    # 2. save properties
    data.each_pair do |name, value|
      unless %w[name description image].include?(name)
        v = if value.class == Hash || value.class == Array
              value.to_json
            else
              value.to_s
            end
        Property.create(
          name: name,
          value: v,
          token: self
        )
      end
    end

    # 3. save infos
    self.update(
      name: name,
      description: description,
      image_uri: image_uri,
      ipfs: is_ipfs,

      token_uri_err: nil,
      token_uri_processed: true
    ) 

    # 4.
    broadcast
  rescue => e
    token_uri_err = 
      if e.class == RuntimeError
        e.message
      else
        "#{e.class} (#{e.message})"
      end
    puts "  #{token_uri_err}"
    # puts e.backtrace.join("\n")
    self.update(
      token_uri_err: token_uri_err,
      token_uri_processed: true
    )
  end

  def update_image
    if self.image_uri.present?
      attach_image self.image_uri
    end
  end

  ##################
  ### help methods
  ##################
  def get_token_uri_json
    the_token_uri = get_token_uri

    # convert to gateway url if it is an ipfs scheme
    if the_token_uri.start_with?("ipfs://")
      the_token_uri = "https://dweb.link/ipfs/#{token_uri[7..]}"
    end

    faraday = Faraday.new do |f|
      f.response :follow_redirects
      f.adapter Faraday.default_adapter
    end
    response = faraday.get the_token_uri
    
    if response.status == 200
      body = response.body.gsub("\xEF\xBB\xBF".force_encoding("ASCII-8BIT"), '')
      fixed_body = StringHelper.fix_encoding(body)
      if fixed_body.strip.start_with?("{") 
        return JSON.parse(fixed_body)
      else
        raise "token_uri's response body is not json"
      end
    else
      raise "token_uri's response status is #{response.status}"
    end
  end

  def q_string_of
    self.collection.blockchain_id
  end

  def get_token_uri
    raise "token_uri is blank" if self.token_uri.blank?
    raise "token_uri is not valid" unless self.token_uri =~ URI::regexp

    if self.collection.erc1155? && self.token_uri.include?("{id}")
      hex_token_id_on_chain = self.token_id_on_chain.to_i.to_s(16).rjust(64, "0")
      self.token_uri.gsub("{id}", hex_token_id_on_chain).strip
    else
      self.token_uri.strip
    end
  end
  

  # TODO: more precise
  # https://github.com/ipfs/specs/issues/248
  # https://github.com/ipfs/in-web-browsers/blob/master/ADDRESSING.md
  def is_ipfs_uri?(uri)
    uri.include?("/ipfs/") || uri.start_with?("ipfs://")
  end

  def attach_image(image_uri)
    tempfile, content_type = Download.download_image(image_uri)

    name = Digest::SHA1.hexdigest(image_uri)
    ext = MIME::Types[content_type].first.extensions.first
    filename = "#{name}.#{ext}"

    self.image.attach(io: tempfile, filename: filename)
  end

end
