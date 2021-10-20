module WelcomeHelper
  def token_image(token)
    if token.image.present? && token.image.attached?
      if token.image_size < 20971520
        # Aliyun only support image resize when image size is less than 20971520
        token.image.url(params: { "x-oss-process" => "image/resize,w_250" })
      else
        token.image.url
      end
    else
      image_url("logo-uniscan.png")
    end
  end
end
