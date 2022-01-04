# Token image help methods
class ImageHelper

  # Download the file of image_uri. If it is not a image, try to convert it into a image 
  #
  # Convert to png if the image_uri is a svg.
  # Convert to gif if the image_uri is a video.
  #
  # resize image size to 600x600.
  # keep the aspect ratio.
  #
  # It depends on the +imagemagick+ and +ffmpeg+.
  # @param image_uri [String] the url of the image.
  # @return [Tempfile, String, String] the file, the content type, and the original
  # content type.
  def self.download_and_convert_image(image_uri)
    ori_tempfile = Down.download(image_uri, max_size: 50 * 1024 * 1024) # 50 MB
    ori_content_type = ori_tempfile.content_type

    tempfile, content_type = convert(ori_tempfile, ori_content_type)
    [ tempfile, content_type, ori_content_type ]
  end

  # Convert file
  #
  # 1. svg to png
  # 2. video to gif
  # 3. resize to 600x600 without changing the aspect ratio.
  def self.convert(tempfile, content_type)
    # Convert svg to png
    if content_type.include?("svg")

      tempfile = svg_to_png(tempfile)
      content_type = "image/png"

    # Convert video to gif
    elsif content_type.start_with?("video")

      tempfile = video_to_gif(tempfile)
      content_type = "image/gif"

    end

    if content_type != "image/gif"
      # Shrink Larger Images
      ext = MIME::Types[content_type].first.extensions.first
      tempfile = ImageProcessing::MiniMagick
        .source(tempfile)
        .resize_to_limit(600, 600)
        .convert(ext)
        .strip
        .call
    end

    [ tempfile, content_type ]
  end

  # svg to png converter
  #
  # @param svg_file [Tempfile] the svg file to convert
  # @return [Tempfile]
  def self.svg_to_png(svg_file)
    ImageProcessing::MiniMagick
      .source(svg_file)
      .convert("png")
      .call
  end

  # video to gif converter.
  #
  # @param video_file [Tempfile] the video file to convert
  # @return [Tempfile]
  def self.video_to_gif(video_file)
    gif_file = Tempfile.new(["", ".gif"])
    `#{Rails.root.join("scripts", "vid-to-gif.sh").to_s} -f 10 -w 600 #{video_file.path} #{gif_file.path}`
    gif_file
  end
end
