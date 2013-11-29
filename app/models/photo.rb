class Photo
  attr_reader :title,  :url, :width, :height, :location
  
  def initialize(attrs)
    low_res = attrs[:images][:low_resolution]

    @url = low_res[:url]
    caption = attrs[:caption]
    @title = caption ? caption[:text] : "Untitled" 
    @width = low_res[:width]
    @height = low_res[:height]
    @location = Coordinates.new(attrs[:location])
  end
  
  def coordinate
    @location.to_cl
  end

  def self.search(coordinates, distance, &block)
    params = {
      client_id: ENV['INSTAGRAM_CLIENT_ID'],
      lat: coordinates.latitude, 
      lng: coordinates.longitude,
      distance: distance
    }
    AFMotion::Client.shared.get('media/search', params) do |result|
      if result.success?
        json = result.object
        photos = json['data'].map{|item| Photo.new(item)}
        block.call(photos)
      else
       #something went wrong
       raise "#{result.error.localizedDescription} #{result.body}"
      end
    end
  end
end
