module WelcomeHelper
  def token_image(token)
    if token.image.present? && token.image.attached?
      token.image.url(params: { "x-oss-process" => "image/resize,h_250,w_250" })
    else
      image_url("logo-uniscan.png")
    end
  end
end
