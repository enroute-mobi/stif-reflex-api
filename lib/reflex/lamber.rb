module Reflex
  class LamberWilson
    PROJ4 = '+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'
    WGS84_PROJ4 = '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'
    WKT   = <<-WKT
     PROJCS["RGF93 / Lambert-93",
       GEOGCS["RGF93",
           DATUM["Reseau_Geodesique_Francais_1993",
               SPHEROID["GRS 1980",6378137,298.257222101,
                   AUTHORITY["EPSG","7019"]],
               TOWGS84[0,0,0,0,0,0,0],
               AUTHORITY["EPSG","6171"]],
           PRIMEM["Greenwich",0,
               AUTHORITY["EPSG","8901"]],
           UNIT["degree",0.01745329251994328,
               AUTHORITY["EPSG","9122"]],
           AUTHORITY["EPSG","4171"]],
       UNIT["metre",1,
           AUTHORITY["EPSG","9001"]],
       PROJECTION["Lambert_Conformal_Conic_2SP"],
       PARAMETER["standard_parallel_1",49],
       PARAMETER["standard_parallel_2",44],
       PARAMETER["latitude_of_origin",46.5],
       PARAMETER["central_meridian",3],
       PARAMETER["false_easting",700000],
       PARAMETER["false_northing",6600000],
       AUTHORITY["EPSG","2154"],
       AXIS["X",EAST],
       AXIS["Y",NORTH]]
    WKT
    WGS84_WKT = <<-WKT
      GEOGCS["WGS 84",
        DATUM["WGS_1984",
          SPHEROID["WGS 84",6378137,298.257223563,
            AUTHORITY["EPSG","7030"]],
          AUTHORITY["EPSG","6326"]],
        PRIMEM["Greenwich",0,
          AUTHORITY["EPSG","8901"]],
        UNIT["degree",0.01745329251994328,
          AUTHORITY["EPSG","9122"]],
        AUTHORITY["EPSG","4326"]]
    WKT

    def initialize
      @lamber = RGeo::Cartesian.factory(:srid => 2154, :proj4 => PROJ4, :coord_sys => WKT)
      @wgs84  = RGeo::Geographic.spherical_factory(:srid => 4326, :proj4 => WGS84_PROJ4, :coord_sys => WGS84_WKT)
    end

    def to_wgs84(cord)
      point = self.to_point(cord)
      RGeo::Feature.cast(point, :factory => @wgs84, :project => true)
    end

    def to_longlat(cord)
      point = self.to_wgs84(cord)
      {lng: point.lon, lat: point.lat}
    end

    def to_point(cord)
      cord = cord.split(' ') if cord.is_a? String
      @lamber.point(*cord.map(&:to_f))
    end
  end
end
