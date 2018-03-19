//
//  SearchResultsViewController.swift
//  Online Botika
//
//  Created by dan solano on 19/03/2018.
//  Copyright © 2018 ferrerojosh. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PharmacyDetailViewController: UIViewController {
    
    var place: Place!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textPharmacy: UILabel!
    @IBOutlet weak var textAddress: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()

        // Do any additional setup after loading the view.
        if let url = place.photos?.first?.photoURL(maxWidth: 1920) {
            imageView.af_setImage(withURL: url, completion: onImageDownloaded)
        } else {
            activityIndicator.stopAnimating()
            imageView.image = UIImage(named: "ImagePlaceholder")
        }
        
        textPharmacy.text = place.name
        textAddress.text = place.vicinity
    }
    
    func onImageDownloaded(data: DataResponse<UIImage>) -> Void {
        activityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
