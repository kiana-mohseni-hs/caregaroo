# encoding: utf-8


class NewsUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper


  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def pre_limit file
    require 'debugger'; debugger
    if file && file.size > 5.megabytes
      raise Exception.new("too large")
    end
    true
  end

  def only_first_frame
    manipulate! do |img|

      if img.mime_type.match /gif/
        if img.scene == 0
          img = img.cur_image #Magick::ImageList.new( img.base_filename )[0]
        else
          img = nil
        end
      end
      img
    end
  end

  version :large, if: :pre_limit do
    #process :pre_limit
    process :only_first_frame
    #process :quality => 90
    process :convert => 'jpg'
    process :resize_to_limit => [1280, 1024]
  end

  # Create different versions of your uploaded files:
  version :small, if: :pre_limit do
    #process :pre_limit
    process :only_first_frame
    #process :quality => 90
    process :convert => 'jpg'
    process :resize_to_limit => [360, 360]
  end


  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
