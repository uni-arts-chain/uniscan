class Download

  def self.download_image(image_uri)
    tempfile = Down.download(image_uri, max_size: 5 * 1024 * 1024) # 5 MB

    if tempfile.content_type.include?("svg")
      tempfile = ImageProcessing::MiniMagick
        .source(tempfile)
        .convert("png")
        .call
      content_type = "image/png"
    else
      content_type = tempfile.content_type
    end

    [ tempfile, content_type ]
  end

end
