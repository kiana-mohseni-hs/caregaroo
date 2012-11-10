module CarrierWave
  module RMagick

    def quality(percentage)
      manipulate! do |img|
        img.write(current_path){ self.quality = percentage } unless img.quality == percentage
        img = yield(img) if block_given?
        img
      end
    end

    def pre_limit size_
      manipulate! do |img|
        #require 'debugger'; debugger
        if File.size(current_path) > size_
          raise Exception.new "FileTooLarge"
        end
      end
    end

    def only_first_frame
      manipulate! do |img|
        #require 'debugger'; debugger

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

  end
end