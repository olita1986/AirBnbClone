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
    
    var placeTitle = ""
    var placeType = ""
    var roomType = ""
    var placePrice = ""
    var placeGuests = ""
    var placeBeds = ""
    var placeBedrooms = ""
    var placeBathrooms = ""
    var placePublicAddress = ""
    var id = ""
    var url = ""
    
    var image: UIImage?
    
    var lat = Double()
    var lon = Double()
    
  
    

    @IBOutlet weak var placeImageView: UIImageView!

    @IBOutlet weak var placePriceLabel: UILabel!
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
        
        
        if image != nil {
            
            placeImageView.image = image
            
        } else {
            
            if url.isEmpty {
                
                placeImageView.image = UIImage(named: "house.png")
            } else {
                
                downloadImage(url: url)
                
            }
            
            
        }
        
        
        placeTitleLabel.text = placeTitle
        placePriceLabel.text = placePrice
        placeTypeLabel.text = placeType
        roomTypeLabel.text = roomType
        
        guestLabel.text = placeGuests
        bedroomsLabel.text = placeBedrooms
        bathroomsLabel.text = placeBathrooms
        bedLabel.text = placeBeds
        
        publicAddressLabel.text = placePublicAddress
        
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        
        parseJson(id: id)
        
        setMap(lat: lat, lon: lon)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseJson (id: String) {
        
        let url = URL(string:  "https://api.airbnb.com/v2/listings/" + id + "?client_id=3092nxybyb0otqw18e8nh5nty&_format=v1_legacy_for_p3")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            if error != nil {
                
                print(error)
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                
                        if let result = jsonResult["listing"] as? NSDictionary {
        
                            if let text = result["description"] as? String {
                                
                                
                                print(text)
                                DispatchQueue.main.async() { () -> Void in
                                    
                                    self.descriptionTextView.text = text
                                }
                                
                            }
                            
 
                        }
                        
                        
                        
                        
                    } catch {
                        
                        
                    }
                    
                    
                }
            }
            
        }
        task.resume()

    }
    
    func setMap (lat: Double, lon: Double) {
        
        
        let latitude: CLLocationDegrees = lat
        
        let longitude: CLLocationDegrees = lon
        
        let latDelta: CLLocationDegrees = 0.05
        
        let lonDelta: CLLocationDegrees = 0.05
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.title = placeTitle
        annotation.subtitle = placePrice

        annotation.coordinate = location
        
        mapView.addAnnotation(annotation)
    }
    
    func downloadImage (url: String) {
        
        let url = URL(string: url)!
        
        let request = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                
                print(error)
            } else {
                
                if let data = data {
                    
                    if let image = UIImage(data: data) {
                        
                        
                        DispatchQueue.main.async() { () -> Void in
                            
                            self.placeImageView.image = image
                        }
                        
                    }
                }
            }
            
        }
        
        task.resume()

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
