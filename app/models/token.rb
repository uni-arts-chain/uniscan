require 'mime/types'

# Represents NFTs, currently includes ERC721 and ERC1155 NFTs.
# A +token+ is a NFT.
#
# +token_id_on_chain+ is the token_id from the contract.  
# +owner_id+ only used by ERC721.  
# +unique+ is true if the token is a ERC721 NFT.  
# +supply+ is not from chain, but calculating after the token_ownership updated.  
# +name+, +description+, and +image_uri+ are from token_uri's metadata.  
# +image_ori_content_type+ records the ori content type of the token image. Because
# the ori image may be converted(svg, video).  
# +image_size+ records the converted image's size. Used by displaying the image.
# Online OSS(Object Storage Service) resize function always has a limit in size.
#
# == Schema Information
#
# Table name: tokens
#
#  id                     :bigint           not null, primary key
#  token_id_on_chain      :string(255)
#  collection_id          :integer
#  unique                 :boolean          default(TRUE)
#  supply                 :decimal(65, )    default(1)
#  owner_id               :integer
#  name                   :text(65535)
#  description            :text(65535)
#  image_uri              :text(65535)
#  token_uri              :text(65535)
#  token_uri_err          :text(65535)
#  ipfs                   :boolean          default(FALSE)
#  transfers_count        :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  holders_count          :integer          default(0)
#  token_uri_processed    :boolean          default(FALSE)
#  transfers_count_24h    :integer          default(0)
#  transfers_count_7d     :integer          default(0)
#  last_transfer_time     :datetime
#  image_ori_content_type :string(255)
#  image_size             :integer          default(0)
#
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
      # "collection_id != 19"
    )
  }

  # Owned by how many people in history.
  # @return [Integer] the owners count in history.
  def historical_owners_count
    Transfer.where(token: self).distinct.count(:token_id)
  end

  # The current owner of the token.
  #
  # Returns the first owner if it is a ERC1155 token that can have multi owners.
  # @return [Account] the token's owner.
  def owner
    self.accounts[0]
  end

  # The current owners of the token.
  #
  # @return [Array<Account>] the token's owners.
  def owners
    self.accounts
  end

  # Broadcast the token html segemnt to user's browser through websocket.
  def broadcast
    broadcast_prepend_to('tokens') 

    broadcast_prepend_to("tokens:#{self.collection.blockchain_id}:_")
    broadcast_prepend_to("tokens:_:#{self.collection.nft_type_before_type_cast}")
    broadcast_prepend_to("tokens:#{self.collection.blockchain_id}:#{self.collection.nft_type_before_type_cast}")
  end

  # Clean the token uri processed infos.
  # 
  # 1. purge image
  # 2. delete all properties
  # 3. clean the metadata
  # 3. revert the status
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

  # Get and save the metadata of the token by processing the token uri.
  #
  # 1. Read content from the token_uri.
  # 2. Save content to database.
  # 3. Process the image (convert if needed).
  # 4. Attach the image.
  # 5. Save the processing status(ok or fail) to database.
  #
  # This method is called by rake task +token_uri:parse+
  def process_token_uri
    data = TokenUriHelper.get_content(get_token_uri)

    name = data["name"]
    description = data["description"]
    image_uri = data["image"]

    raise "The image is required" if image_uri.blank?
    raise "This nft is deprecated" if image_uri == 'https://mcp3d.com/api/image/deprecated'
    raise "The image uri is too long" if image_uri.length > 2048 # chrome url limit
    raise "The name is too long" if name && name.length > 65535
    raise "The description is too long" if description && description.length > 65535
    raise "Blacklisted" if self.collection.contract_address == "0xd1e5b0ff1287aa9f9a268759062e4ab08b9dacbe" # .crypto

    token_uri = self.token_uri&.strip
    is_ipfs = is_ipfs_uri?(token_uri) && is_ipfs_uri?(image_uri)

    # 1. save base info to db
    self.update(
      name: name,
      description: description,
      image_uri: image_uri,
      ipfs: is_ipfs,
    ) 

    # 2. save properties to db
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

    # 3. attach image
    attach_image

    # 4. fininshed
    self.update(
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
    puts e.backtrace.join("\n")
    self.update(
      token_uri_err: token_uri_err,
      token_uri_processed: true
    )
  end

  # Returns the attached image
  #
  # Reprocess token_uri if attached image has an svg attachement.
  def get_image
    if self.image.attached? 
      if self.image.blob.content_type.include?("svg")
        process_token_uri
      end
      self.image
    else
      process_token_uri
      self.image
    end
  end

  # Get the token_uri's content as a json object.
  #
  # @return [Object] the token_uri's content which must contains the +image+ item.
  def get_token_uri_json

  end

  # Get the final token uri.
  #
  # Raise error if it is a bad uri.
  # Preprocess if the token is a ERC1155 NFT.
  # @return [String] the final token uri
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
  

  # Check if a url is an ipfs uri.
  #
  # TODO: more precise  
  # {https://github.com/ipfs/specs/issues/248}  
  # {https://github.com/ipfs/in-web-browsers/blob/master/ADDRESSING.md}  
  def is_ipfs_uri?(uri)
    uri.include?("/ipfs/") || uri.start_with?("ipfs://")
  end

  # Download, convert, and attach(save or upload) the image of the token.
  #
  # production:  
  # * upload the image to aliyun oss.
  #
  # development or test:
  # * save to local disk.
  #
  # See config/storage.yml
  def attach_image
    url = if self.image_uri.start_with?("ipfs://")
            "https://dweb.link/ipfs/#{self.image_uri[7..]}"
          else
            self.image_uri
          end
    tempfile, content_type, ori_content_type = ImageHelper.download_and_convert_image(url)

    name = Digest::SHA1.hexdigest(self.image_uri)
    ext = MIME::Types[content_type].first.extensions.first
    filename = "#{name}.#{ext}"

    self.image.attach(io: tempfile, filename: filename)
    self.update(
      image_size: tempfile.size, # it is not the originally image file size
      image_ori_content_type: ori_content_type
    )
  end

end
