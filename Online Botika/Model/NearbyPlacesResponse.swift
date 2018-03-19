//
//  NearbyPlaceResponse.swift
//  Online Botika
//
//  Created by dan solano on 11/03/2018.
//  Copyright © 2018 ferrerojosh. All rights reserved.
//

import Foundation

struct NearbyPlacesResponse {
    var nextPageToken: String?
    var status: String  = "NOK"
    var places: [Place]?
    
    init?(dic:[String : Any]?) {
        nextPageToken = dic?["next_page_token"] as? String
        
        if let status = dic?["status"] as? String {
            self.status = status
        }
        
        if let results = dic?["results"] as? [[String : Any]]{
            var places = [Place]()
            for place in results {
                places.append(Place.init(placeInfo: place))
            }
            self.places = places
        }
    }
    
    var canLoadMore: Bool {
        if status == "OK" && nextPageToken != nil && nextPageToken?.count ?? 0 > 0 {
            return true
        }
        return false
    }
}

