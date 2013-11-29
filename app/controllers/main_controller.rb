class MainController < UIViewController
  extend IB

  ## ib outlets
  outlet :map, MKMapView
  outlet :activity, UIActivityIndicatorView
  outlet :slider, UISlider
  ib_action :slider_value_changed

  def mapView(map, didUpdateUserLocation:user_location)
    return unless has_user_coordinate?
    set_map_region
    show_nearby_photos
  end

  def mapView(map, didSelectAnnotationView:view)
    if view.annotation.respond_to? :url
      AFMotion::Image.get(view.annotation.url) do |result|
        image_view = UIImageView.alloc.initWithImage(result.object)
        self.presentSemiView(image_view)
        self.resizeSemiView(image_view.bounds.size)
      end
    end
  end

  private
  def show_nearby_photos
    clean_annotations

    activity.startAnimating
    Photo.search(user_coordinate, region_distance_meters) do |photos|
      activity.stopAnimating
      photos.each do |photo|
        map.addAnnotation(photo)
      end
    end
  end

  def clean_annotations
    photo_annotations = map.annotations.reject{|a| a == map.userLocation}
    map.removeAnnotations(photo_annotations)
  end

  def set_map_region
    map.setCenterCoordinate(user_coordinate, animated:true)
    region = MKCoordinateRegionMakeWithDistance(user_coordinate,region_distance_meters,region_distance_meters)
    map.setRegion(region)
  end

  def has_user_coordinate?
    map.userLocation.location
  end

  def user_coordinate
    map.userLocation.location.coordinate
  end

  def slider_value_changed(sender)
    set_map_region
    show_nearby_photos
  end

  def region_distance_meters
    slider.value * 5000
  end
end
