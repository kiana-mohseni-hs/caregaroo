# encoding: utf-8

class NewsUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  #include Sprockets::Helpers::RailsHelper
  #include Sprockets::Helpers::IsolatedHelper


  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end


  process :resize_to_limit => [1024, 1024]

  # Create different versions of your uploaded files:
  version :small do
    process :resize_to_limit => [360, 360]
  end


  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
