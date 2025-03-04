//
//  File.swift
//  H3kit
//
//  Created by Tom Brewe on 04.03.25.
//


public extension H3.Resolution {
    var hexSqmArea: Double {
        /// see https://h3geo.org/docs/core-library/restable
        switch self {
        case .zero:
            4_357_449_416_078.392
        case .one:
            609_788_441_794.134
        case .two:
            86_801_780_398.997
        case .three:
            12_393_434_655.088
        case .four:
            1_770_347_654.491
        case .five:
            252_903_858.182
        case .six:
            36_129_062.164
        case .seven:
            5_161_293.360
        case .eight:
            737_327.598
        case .nine:
            105_332.513
        case .ten:
            15_047.502
        case .eleven:
            2_149.643
        case .twelve:
            307.092
        case .thirteen:
            43.870
        case .fourteen:
            6.267
        case .fifteen:
            0.895
        }
    }
}
