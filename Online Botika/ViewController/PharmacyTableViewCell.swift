//
//  PharmacyTableViewCell.swift
//  Online Botika
//
//  Created by dan solano on 19/03/2018.
//  Copyright © 2018 ferrerojosh. All rights reserved.
//

import UIKit

class PharmacyTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var textPharmacy: UILabel!
    @IBOutlet private weak var textPrice: UILabel!
    @IBOutlet weak var textAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setPrice(price: Double) {
        textPrice.text = String(format: "PHP %.2f", price)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
