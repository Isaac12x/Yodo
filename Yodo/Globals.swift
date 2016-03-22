//
//  Globals.swift
//  Yodo
//
//  Created by Isaac Albets Ramonet on 20/03/16.
//  Copyright © 2016 udacity. All rights reserved.
//

import Foundation

class Globals : NSObject {
    
    // Mashape API Header keys
    
    struct HTTPHeaderKeys {
        static let MashapeKey = "X-Mashape-Key"
        static let Connection = "Accept"
        static let ContentType = "Content-Type"
    }
    
    struct HTTPHeaderValues {
        static let KeyValue = "DEMZNnyNOWmsh0KbK1FUVAidlyc3p1J5jKpjsnXaKKCuPO0Efh"
        static let Text = "text/plain"
        static let ContentValue = "application/x-www-form-urlencoded"
        static let JSON = "application/json"
    }

}