module WelcomeHelper
  # Returns the thumbnail url of the nft image.
  #
  # production:  
  # 1. it returns the aliyun url with resize params if the image size small than 20971520. 
  # 2. it returns the aliyun url without resize params. Because aliyun can not resize too large image.
  #
  # development:
  # 1. it returns the active storage url.
  def token_image(token)
    if token.image.present? && token.image.attached?
      if Rails.env == "production"
        if token.image_size < 20971520
          # Aliyun only support image resize when image size is less than 20971520
          token.image.url(params: { "x-oss-process" => "image/resize,w_250" })
        else
          token.image.url
        end
      else
        url_for token.image
      end
    else
      image_url("logo-uniscan.png")
    end
  end
end
