import CoreLocation
import Foundation

// NOTE: To not expose raw non-bridged C-definitions we mark the wrapped library as an internal import
// If you want to access C-functions when using this package, just remove the `internal` keyword.
internal import H3kitC

public typealias H3Index = UInt64

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}
public extension CLLocationCoordinate2D {
    static func h3CellCenter(h3Index: UInt64) -> Self {
        var location = LatLng()
        cellToLatLng(h3Index, &location)
        let lat = location.lat.radiansToDegrees
        let lng = location.lng.radiansToDegrees
        return .init(latitude: lat, longitude: lng)
    }
    
    // Find the H3 cell index for a given set of 2D coordinates
    func h3CellIndex(resolution: Int32) -> H3Index {
        let lat = latitude.degreesToRadians
        let lng = longitude.degreesToRadians
        var location = LatLng(lat: lat, lng: lng)
        var index = H3Index()
        latLngToCell(&location, resolution, &index)
        return index
    }

    // Find the neighbor cells for a given set of 2D coordinates and ring size
    func h3Neighbors(resolution: Int32, ringLevel: Int32) -> [H3Index] {
        let index = h3CellIndex(resolution: resolution)
        var count: Int64 = .init()
        maxGridDiskSize(ringLevel, &count)
        var neighbors = Array(repeating: H3Index(), count: Int(count))
        gridDisk(index, ringLevel, &neighbors)
        return neighbors
    }
}
