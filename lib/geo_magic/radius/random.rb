module GeoMagic
  class Radius
    module Random
    def create_points_in_square number
      conversion = GeoDistance.radians_ratio(distance.unit)

      max_radius_rad = distance.distance
      range = normalize max_radius_rad

      number.times.inject([]) do |res, n|
        dlong = denormalize get_random_radiant(range)
        dlat  = denormalize get_random_radiant(range)

        point = GeoMagic::Point.new @center.latitude + dlat, @center.longitude + dlong
        res << point
        res
      end
    end  

    def create_points_in_circle number
      conversion = GeoDistance.radians_ratio(distance.unit)

      max_radius_rad = distance.distance
      range = normalize max_radius_rad

      max_radius_rad = distance.distance
      range = normalize max_radius_rad

      number.times.inject([]) do |res, n|
        q = rand(range) * PI_2
        r = Math.sqrt(rand(range))

        dlong = denormalize (range * r) * Math.cos(q)
        dlat  = denormalize (range * r) * Math.sin(q)

        point = GeoMagic::Point.new @center.latitude + dlat, @center.longitude + dlong
        res << point
        res
      end
    end  

    def create_point_within_square 
      conversion = GeoDistance.radians_ratio(distance.unit)      

      max_radius_rad = dist.distance
      range = (max_radius_rad * normalize).to_i          

      dlong = (get_random_radiant(range) / normalize)
      dlat  = (get_random_radiant(range) / normalize)
  
      GeoMagic::Point.new @center.latitude + dlat, @center.longitude + dlong
    end
    
    def create_point_within_circle
      max_radius_rad = dist.distance
      range = normalize max_radius_rad

      q = rand(range) * PI_2
      r = Math.sqrt(rand(range))
      dlong = denormalize (range * r) * Math.cos(q)
      dlat = denormalize (range * r) * Math.sin(q)
  
      GeoMagic::Point.new @center.latitude + dlat, @center.longitude + dlong      
    end

    def get_random_radiant range
      self.class.get_random_radiant range
    end

    def self.get_random_radiant range
      rand(range * 2) - range
    end
  end
end