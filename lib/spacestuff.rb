require "spacestuff/version"
require "RMagick"

module Spacestuff
  class Setup
    def self.run
      specified_category = ARGV.shift

      categories = [
        "sushi",
        "broccoli",
        "mashroom",
        "gorilla"
      ]

      if !categories.include?(specified_category) then
        category = categories.sample
      else
        category = specified_category
      end

      bgs = Dir[File.expand_path("../..", __FILE__) + "/assets/images/backgrounds/*"]
      bg = Magick::Image.read(bgs.sample).first
      stuff_list = Dir[File.expand_path("../..", __FILE__) + "/assets/images/stuff/" + category + "/*"]
      stuff = Magick::Image.read(stuff_list.sample).first

      bg_width = bg.columns
      bg_height = bg.rows
      stuff_width = stuff.columns
      stuff_height = stuff.rows

      min_x = 0
      min_y = 0
      max_x = bg_width - stuff_width
      max_y = bg_height - stuff_height
      filename = "result.jpg"
      max_stuff_count = 10
      image_format = "JPEG"
      image_quality = 50

      rand(1..max_stuff_count).times do

        if rand(0..2) == 0 then
          modified_stuff = stuff.flip
        else
          modified_stuff= stuff
        end

        if rand(0..2) == 0 then
          modified_stuff = modified_stuff.flop
        else
          modified_stuff = modified_stuff
        end

        modified_stuff.background_color = "none"
        modified_stuff = modified_stuff.rotate(rand(0..360))

        if @result then
          bg = @result
        end

        @result = bg.composite(
          modified_stuff,
          rand(min_x..max_x),
          rand(min_y..max_y),
          Magick::OverCompositeOp
        )

      end
      @result.write(filename) do
        self.format = image_format
        self.quality = image_quality
      end
    end
  end
end
