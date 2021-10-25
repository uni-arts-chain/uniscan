require "test_helper"

class ImageHelperTest < ActiveSupport::TestCase
  test "can convert svg to png" do
    file = File.new("#{Rails.root}/test/assets/2.svg")
    content_type = "image/svg+xml"
    converted_file, converted_file_content_type = ImageHelper.convert(file, content_type)

    assert_equal converted_file_content_type, "image/png"
    assert `magick identify #{converted_file.path}`.split(" ")[1] == "PNG"
  end

  # https://dl8.webmfiles.org/big-buck-bunny_trailer.webm
  # TODO: test more video type
  test "can convert video to gif - webm" do
    file = File.new("#{Rails.root}/test/assets/4.webm")
    content_type = "video/webm"
    converted_file, converted_file_content_type = ImageHelper.convert(file, content_type)

    assert_equal converted_file_content_type, "image/gif"
    assert `magick identify #{converted_file.path}`.split(" ")[1] == "GIF"
  end

  # https://samplelib.com/sample-mp4.html
  test "can convert video to gif - mp4" do
    file = File.new("#{Rails.root}/test/assets/5.mp4")
    content_type = "video/mp4"
    converted_file, converted_file_content_type = ImageHelper.convert(file, content_type)

    assert_equal converted_file_content_type, "image/gif"
    assert `magick identify #{converted_file.path}`.split(" ")[1] == "GIF"
  end

  test "should resize big image to 600x600" do 
    file = File.new("#{Rails.root}/test/assets/1.png")
    content_type = "image/png"
    converted_file, converted_file_content_type = ImageHelper.convert(file, content_type)

    assert_equal converted_file_content_type, "image/png"
    info = `magick identify #{converted_file.path}`.split(" ")
    assert info[1] == "PNG"
    assert info[2].start_with?("600x600")
  end

  test "should keep ratio after convert" do
    info = `magick identify "#{Rails.root}/test/assets/6.png"`.split(" ")
    assert_equal info[2], "940x528"

    file = File.new("#{Rails.root}/test/assets/6.png")
    content_type = "image/png"
    converted_file, converted_file_content_type = ImageHelper.convert(file, content_type)

    assert_equal converted_file_content_type, "image/png"
    info = `magick identify #{converted_file.path}`.split(" ")
    assert info[1] == "PNG"
    assert info[2].start_with?("600x337")
  end

  test "should not resize small image smaller than 600x600" do 
    file = File.new("#{Rails.root}/test/assets/3.gif")
    content_type = "image/gif"
    converted_file, converted_file_content_type = ImageHelper.convert(file, content_type)

    assert_equal converted_file_content_type, "image/gif"
    info = `magick identify #{converted_file.path}`.split(" ")
    assert info[1] == "GIF"
    assert info[2].start_with?("82x100")
  end
end
