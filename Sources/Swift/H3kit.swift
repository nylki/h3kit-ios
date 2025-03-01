import CoreLocation
import Foundation

// NOTE: To not expose raw non-bridged C-definitions we mark the wrapped library as an internal import
// If you want to access C-functions when using this package, just remove the `internal` keyword.
internal import H3kitC

public typealias H3Index = UInt64

public extension CLLocationCoordinate2D {
    static func h3CellCenter(h3Index: UInt64) -> Self {
        var location = GeoCoord()
        h3ToGeo(h3Index, &location)
        let lat = radsToDegs(location.lat)
        let lon = radsToDegs(location.lon)
        return .init(latitude: lat, longitude: lon)
    }
    
    // Find the H3 cell index for a given set of 2D coordinates
    func h3CellIndex(resolution: Int32) -> H3Index {
        let lat = degsToRads(latitude)
        let lon = degsToRads(longitude)
        var location = GeoCoord(lat: lat, lon: lon)
        let index = geoToH3(&location, resolution)
        return index
    }

    // Find the neighbor cells for a given set of 2D coordinates and ring size
    func h3Neighbors(resolution: Int32, ringLevel: Int32) -> [H3Index] {
        let index = h3CellIndex(resolution: resolution)
        let count = Int(maxKringSize(ringLevel))
        var neighbors = Array(repeating: H3Index(), count: count)
        kRing(index, ringLevel, &neighbors)
        return neighbors
    }
}
