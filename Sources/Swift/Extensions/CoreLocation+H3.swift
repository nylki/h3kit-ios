import CoreLocation

public extension CLLocationCoordinate2D {
    static func h3CellCenter(h3Index: UInt64) throws -> Self {
        let (lat, lng) = try H3.cellToLatLng(h3Index: h3Index)
        return .init(
            latitude: lat.radiansToDegrees,
            longitude: lng.radiansToDegrees
        )
    }
    
    // Find the H3 cell index for a given set of 2D coordinates
    func h3CellIndex(resolution: Int32) throws -> H3Index {
        try H3.latLngToCell(
            lat: latitude.degreesToRadians,
            lng: longitude.degreesToRadians,
            resolution: resolution
        )
    }

    // Find the neighbor cells for a given set of 2D coordinates and ring size
    func h3Neighbors(resolution: Int32, ringLevel: Int32) throws -> [H3Index] {
        try H3.neighbors(
            lat: latitude.degreesToRadians,
            lng: longitude.degreesToRadians,
            resolution: resolution,
            ringLevel: ringLevel
        )
    }
}
