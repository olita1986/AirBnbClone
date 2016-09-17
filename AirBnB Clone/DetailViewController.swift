//
//  DetailViewController.swift
//  AirBnB Clone
//
//  Created by orlando arzola on 17.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var placeImageView: UIImageView!

    @IBOutlet weak var placeTitleLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    @IBOutlet weak var guestLabel: UILabel!
    @IBOutlet weak var bedroomsLabel: UILabel!
    @IBOutlet weak var bedLabel: UILabel!
    @IBOutlet weak var bathroomsLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var publicAddressLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Detail"
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
