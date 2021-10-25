# Token image help methods
class ImageHelper

  # Download the file of image_uri. If it is not a image, try to convert it into a image 
  #
  # Convert to png if the image_uri is a svg.
  # Convert to gif if the image_uri is a video.
  #
  # resize image size to 600x600.
  # keep the aspect ratio.
  def self.download_and_convert_image(image_uri)
    tempfile = Down.download(image_uri, max_size: 50 * 1024 * 1024) # 50 MB
    content_type = tempfile.content_type
    ori_content_type = content_type

    # Convert svg to png
    if ori_content_type.include?("svg")
      tempfile = ImageProcessing::MiniMagick
        .source(tempfile)
        .convert("png")
        .call
      content_type = "image/png"
    end

    # Convert video to gif
    if ori_content_type.start_with?("video")
      tempfile = video_to_gif(tempfile)
      content_type = "image/gif"
    end

    # Shrink Larger Images
    ext = MIME::Types[content_type].first.extensions.first
    tempfile = ImageProcessing::MiniMagick
      .source(tempfile)
      .resize_to_limit(600, 600)
      .convert(ext)
      .strip
      .call

    [ tempfile, content_type, ori_content_type ]
  end

  # video to gif converter.
  def self.video_to_gif(video_file)
    gif_file = Tempfile.new(["", ".gif"])
    `#{Rails.root.join("scripts", "vid-to-gif.sh").to_s} -f 10 -w 600 #{video_file.path} #{gif_file.path}`
    gif_file
  end
end
