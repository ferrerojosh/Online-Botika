//
//  NearbyPlaceController.swift
//  Online Botika
//
//  Created by dan solano on 11/03/2018.
//  Copyright © 2018 ferrerojosh. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class NearbyPlacesController {
    static let photoApiHost = "https://maps.googleapis.com/maps/api/place/photo"
    static let googlePlaceDetailsHost = "https://maps.googleapis.com/maps/api/place/details/json"
    static let searchApiHost = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    
    static func nearbyPlaces(by category:String, coordinates: CLLocationCoordinate2D, radius:Int, token: String?, completion: @escaping (NearbyPlacesResponse?) -> Void) {
        
        var params : [String : Any]
        
        if let t = token {
            params = [
                "key" : AppDelegate.googlePlacesKey,
                "pagetoken" : t,
            ]
        } else {
            params = [
                "key" : AppDelegate.googlePlacesKey,
                "location" : "\(coordinates.latitude),\(coordinates.longitude)",
                "type" : category.lowercased(),
                "rankby": "distance"
            ]
        }
        
        Alamofire.request(searchApiHost, parameters: params, encoding: URLEncoding(destination: .queryString)).responseJSON { response in
            
            let response = NearbyPlacesResponse.init(dic: response.result.value as? [String: Any])
            completion(response)
        }
    }
    
    static func googlePhotoURL(photoReference: String, maxWidth: Int) -> URL? {
        return URL.init(string: "\(photoApiHost)?maxwidth=\(maxWidth)&key=\(AppDelegate.googlePlacesKey)&photoreference=\(photoReference)")
    }
}

