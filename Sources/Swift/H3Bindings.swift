//
//  File.swift
//  H3kit
//
//  Created by Tom Brewe on 03.03.25.
//

import Foundation

// NOTE: To not expose raw non-bridged C-definitions we mark the wrapped library as an internal import
// If you want to access C-functions when using this package, just remove the `internal` keyword.
internal import H3kitC

public typealias H3Index = UInt64

public extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}

public enum H3BindingError: Error {
    case undefinedErrorCode(UInt32)
}

public enum H3Error: UInt32, Error {
    
    // NOTE: Since Errors in Swift are not just return codes and can be thrown/catched
    // E_SUCCESS (0) will not be considered an Error! See the initializer below.
    
    /// The operation failed but a more specific error is not available/
        case E_FAILED = 1
    /// Argument was outside of acceptable range (when a more
    /// specific error code is not available)
        case E_DOMAIN = 2
    /// Latitude or longitude arguments were outside of acceptable range
        case E_LATLNG_DOMAIN = 3
    /// Resolution argument was outside of acceptable range
        case E_RES_DOMAIN = 4
    /// `H3Index` cell argument was not valid
        case E_CELL_INVALID = 5
    /// `H3Index` directed edge argument was not valid
        case E_DIR_EDGE_INVALID = 6
    /// `H3Index` undirected edge argument was not valid
        case E_UNDIR_EDGE_INVALID = 7
    /// `H3Index` vertex argument was not valid
        case E_VERTEX_INVALID = 8
    /// Pentagon distortion was encountered which the algorithm could not handle it
        case E_PENTAGON = 9
    /// Duplicate input was encountered in the arguments and the algorithm could not handle it
        case E_DUPLICATE_INPUT = 10
    /// `H3Index` cell arguments were not neighbors
        case E_NOT_NEIGHBORS = 11
    /// `H3Index` cell arguments had incompatible resolutions
        case E_RES_MISMATCH = 12
    /// Necessary memory allocation failed
        case E_MEMORY_ALLOC = 13
    /// Bounds of provided memory were not large enough
        case E_MEMORY_BOUNDS = 14
    /// Mode or flags argument was not valid.
        case E_OPTION_INVALID = 15
    
    init?(code: H3kitC.H3Error) throws {
        guard code != 0 else {
            // NOTE: Since Errors in Swift are not just return codes and can be thrown/catched
            // E_SUCCESS (0) will not be considered an Error!
            return nil
        }
        
        guard let error = Self(rawValue: code) else {
            throw H3BindingError.undefinedErrorCode(code)
        }
        
        self = error
    }
}

/// Define minimal binding to the C functions
public enum H3 {
    /// Determines the spherical coordinates of the center point of an H3 index.
    public static func cellToLatLng(h3Index: UInt64) throws -> (lat: Double, lng: Double) {
        var location = LatLng()
        let returnCode = H3kitC.cellToLatLng(h3Index, &location)
        if let error = try H3Error(code: returnCode) {
            throw error
        }
        return (location.lat, location.lng)
    }

    public static func latLngToCell(lat: Double, lng: Double, resolution: Resolution) throws -> H3Index {
        var location = LatLng(lat: lat, lng: lng)
        var index = H3Index()
        let returnCode = H3kitC.latLngToCell(&location, resolution.rawValue, &index)
        if let error = try H3Error(code: returnCode) {
            throw error
        }
        return index
    }
    
    public static func getResolution(index: H3Index) -> Resolution? {
        let rawRes = H3kitC.getResolution(index)
        return .init(rawValue: rawRes)
    }

    public static func gridDisk(index: H3Index, ringLevel: Int32) -> [H3Index] {
        var count: Int64 = .init()
        maxGridDiskSize(ringLevel, &count)
        var cells = Array(repeating: H3Index(), count: Int(count))
        H3kitC.gridDisk(index, ringLevel, &cells)
        return cells
    }
    
    public static func cellToParent(cell: H3Index, parentRes: Resolution) throws -> H3Index {
        var parent: H3Index = .init()
        let returnCode = H3kitC.cellToParent(cell, parentRes.rawValue, &parent)
        if let error = try H3Error(code: returnCode) {
            throw error
        }
        return parent
    }
    
    public static func cellToChildren(cell: H3Index, childRes: Resolution) throws -> [H3Index] {
        let childrenSize = try cellToChildrenSize(cell: cell, childRes: childRes)
        var children = Array(repeating: H3Index(), count: Int(childrenSize))
        let returnCode = H3kitC.cellToChildren(cell, childRes.rawValue, &children)
        if let error = try H3Error(code: returnCode) {
            throw error
        }
        return children
    }
    
    public static func cellToChildrenSize(cell: H3Index, childRes: Resolution) throws -> Int64 {
        var size: Int64 = .init()
        let returnCode = H3kitC.cellToChildrenSize(cell, childRes.rawValue, &size)
        if let error = try H3Error(code: returnCode) {
            throw error
        }
        return size
    }
}

