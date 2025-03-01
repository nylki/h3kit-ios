import CoreLocation
@testable import H3kit
import H3kitC
import XCTest

struct TestItem {

    let coordinate: CLLocationCoordinate2D
    let resolution: Int32
    
    /// the calculated H3-Index for above latitude and longitude
    let h3Index: H3Index
    /// the center of the H3-Cell for the given sample coordinates
    let centerOfH3Index: CLLocationCoordinate2D
    
    static var sample: Self {
        .init(
            coordinate: .init(latitude: 37.5642135, longitude: 127.0016985),
            resolution: 14,
            h3Index: 640371092026114823,
            centerOfH3Index: .init(latitude: 37.56420549132848, longitude: 127.00170711617017)
        )
    }
}

final class H3kitTests: XCTestCase {
    
    func testGeoToH3() throws {
        let testItem = TestItem.sample
        let coordinate = testItem.coordinate
        let resolution = testItem.resolution
        let expectedH3Index = testItem.h3Index
        let calculatedIndex = coordinate.h3CellIndex(resolution: resolution)
        
        XCTAssertEqual(calculatedIndex, expectedH3Index, "Conversion from lat, lon to h3 index")

        var geoCoord = GeoCoord()
        h3ToGeo(calculatedIndex, &geoCoord)
        print(radsToDegs(geoCoord.lat), radsToDegs(geoCoord.lon))

        let neighbors = coordinate.h3Neighbors(resolution: resolution, ringLevel: 1)
        for item in neighbors {
            print(item)
        }
        XCTAssertEqual(0, 0, "Row count was not zero.")
    }
    
    func testH3ToGeo() throws {
        let testItem = TestItem.sample
        let expectedCellCenter = TestItem.sample.centerOfH3Index
        let cellCenter = CLLocationCoordinate2D.h3CellCenter(h3Index: testItem.h3Index)
        XCTAssertEqual(cellCenter.latitude, expectedCellCenter.latitude, "We expect the latitude to match")
        XCTAssertEqual(cellCenter.longitude, expectedCellCenter.longitude, "We expect the longitude to match")
    }
}
