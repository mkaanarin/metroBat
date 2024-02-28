//
//  infoView.swift
//  metroBat
//
//  Created by Mustafa Kaan Arın on 19.02.2024.
//

import UIKit
import Firebase



class infoView: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    
    var selectedTitle = ""
    var selectedInfo = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.text = selectedInfo
        movieTitle.text = selectedTitle

    }
}



