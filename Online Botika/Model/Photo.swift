//
//  Photo.swift
//  Online Botika
//
//  Created by dan solano on 19/03/2018.
//  Copyright © 2018 ferrerojosh. All rights reserved.
//

import UIKit

private let widthKey = "width"
private let heightKey = "height"
private let photoReferenceKey = "photo_reference"

class Photo: NSObject {
    var width: Int?
    var height: Int?
    var photoRef: String?
    
    init(photoInfo: [String:Any]) {
        height = photoInfo[heightKey] as? Int
        width = photoInfo[widthKey] as? Int
        photoRef = photoInfo[photoReferenceKey] as? String
    }
    
    func photoURL(maxWidth: Int) -> URL? {
        if let ref = self.photoRef {
            return NearbyPlacesController.googlePhotoURL(photoReference: ref, maxWidth: maxWidth)
        }
        return nil
    }
}
