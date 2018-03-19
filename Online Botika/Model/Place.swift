//
//  Place.swift
//  Online Botika
//
//  Created by dan solano on 11/03/2018.
//  Copyright © 2018 ferrerojosh. All rights reserved.
//

import UIKit
import CoreLocation

private let geometryKey = "geometry"
private let locationKey = "location"
private let latitudeKey = "lat"
private let longitudeKey = "lng"
private let nameKey = "name"
private let openingHoursKey = "opening_hours"
private let openNowKey = "open_now"
private let vicinityKey = "vicinity"
private let typesKey = "types"
private let photosKey = "photos"

class Place : NSObject {
    var placeId: String
    var location: CLLocationCoordinate2D?
    var name: String?
    var vicinity: String?
    var isOpen: Bool?
    var types: [String]?
    var photos: [Photo]?
    
    init(placeInfo:[String: Any]) {
        // id
        placeId = placeInfo["place_id"] as! String
        
        // coordinates
        if let g = placeInfo[geometryKey] as? [String:Any] {
            if let l = g[locationKey] as? [String:Double] {
                if let lat = l[latitudeKey], let lng = l[longitudeKey] {
                    location = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
                }
            }
        }
        
        // name
        name = placeInfo[nameKey] as? String
        
        // opening hours
        if let oh = placeInfo[openingHoursKey] as? [String:Any] {
            if let on = oh[openNowKey] as? Bool {
                isOpen = on
            }
        }
        
        // vicinity
        vicinity = placeInfo[vicinityKey] as? String
        
        // types
        types = placeInfo[typesKey] as? [String]
        
        // photos
        photos = [Photo]()
        
        if let ps = placeInfo[photosKey] as? [[String: Any]] {
            for p in ps {
                photos?.append(Photo.init(photoInfo: p))
            }
        }
    }
}

