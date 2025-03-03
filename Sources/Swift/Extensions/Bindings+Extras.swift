//
//  H3Bindings+Convenience.swift
//  H3kit
//
//  Created by Tom Brewe on 03.03.25.
//

/// Define convenience functions that are **not part of the upstream C spec**
extension H3 {
    // Find the neighbor cells for a given set of 2D coordinates in rad and ring size
    static func neighbors(lat: Double, lng: Double, resolution: Int32, ringLevel: Int32) throws -> [H3Index] {
        let index = try latLngToCell(lat: lat, lng: lng, resolution: resolution)
        return gridDisk(index: index, resolution: resolution, ringLevel: ringLevel)
    }
}
