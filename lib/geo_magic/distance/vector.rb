require 'sugar-high/kind_of'

module GeoMagic
  class Distance
    class Vector 
      attr_accessor :lat_distance, :long_distance

      # should be Distance objects!
      def initialize lat_distance, long_distance
        raise ArgumentError, "lat and long distance arguments must be instances of GeoMagic::Distance, was: #{lat_distance} #{long_distance}" if ![long_distance, lat_distance].only_kinds_of? GeoMagic::Distance
        @lat_distance   = lat_distance
        @long_distance  = long_distance
      end      

      def * arg
        multiply arg
      end

      def multiply arg
        factors = case arg
        when Numeric
          [arg, arg]
        when Hash
          [factor(arg, lat_symbols), factor(arg, long_symbols)]
        else
          raise ArgumentError, "Argument must be a Fixnum or a Hash specifying factor to multiply latitude and/or longitude with, was #{arg.class}"
        end                        
        multiply_lat factors.first
        multiply_long factors.last
      end

      def multiply_lat arg
        check_numeric! arg
        self.lat_distance *= arg
      end

      def multiply_long arg
        check_numeric! arg
        self.long_distance *= arg
      end

      def radius center
        GeoMagic::Radius.send :"create_rectangular", center, self
      end

      def to_s
        "distances: (lat: #{lat_distance}, long: #{long_distance})"
      end
      
      protected

      def check_numeric! arg
        raise ArgumentError, "Argument must be Numeric" if !arg.is_a? Numeric
      end

      include GeoMagic::GeoSymbols

      class << self

        include GeoMagic::GeoSymbols

        # should create distance vector from 2 points
        def create_from *args
          case args.size
          when 1
            extract_from_single args.first
          when 2
            new *args
          else
            raise ArgumentError, "Too many arguments! #{args}"
          end
        end

        protected

        def extract_from_single arg
          case arg 
          when GeoMagic::Distance::Vector
            arg
          when GeoMagic::Distance
            new arg, arg
          else  
            new *extract_from_hash(arg)
          end
        end

        def extract_from_hash hash
          raise ArgumentError, "single argument must be a hash" if !hash.kind_of? Hash    
          [lat_dist(hash), long_dist(hash)]
        end

        def lat_dist hash
          sym = lat_symbols.select {|s| hash[s].kind_of? GeoMagic::Distance }.first
          raise ArgumentError, "latitude could not be extracted from hash" if !sym
          hash[sym]
        end

        def long_dist hash
          sym = long_symbols.select {|s| hash[s].kind_of? GeoMagic::Distance }.first
          raise ArgumentError, "longitude could not be extracted from hash" if !sym
          hash[sym]
        end
      end
      
      def factor hash, symbols
        s = symbols.select {|s| hash[s].is_a? Numeric }
        s.empty? ? 1 : hash[s]
      end
    end
  end
end