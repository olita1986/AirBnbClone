//
//  MapViewController.swift
//  AirBnB Clone
//
//  Created by orlando arzola on 15.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //var placesArray = [Dictionary<String, Double>()]
    //var placePrices = [String]()
    
    var locationManager = CLLocationManager()
    var city = ""
    var city2 = ""

    
    

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter =  10
        locationManager.startUpdatingLocation()
    
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        locationManager.startUpdatingLocation()
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMap (lat: Double, lon: Double) {
        
        
        let latitude: CLLocationDegrees = lat
        
        let longitude: CLLocationDegrees = lon
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location, 10000, 10000)

        mapView.setRegion(region, animated: true)
        
        
    }
    
    func getPlacesLocations (city: String) {
        
        let url = URL(string:  "https://api.airbnb.com/v2/search_results?client_id=3092nxybyb0otqw18e8nh5nty&locale=en-US&currency=USD&_format=for_search_results&_limit=30&_offset=0&location=" + city.replacingOccurrences(of: " ", with: "%20"))
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            if error != nil {
                
                print(error)
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject

                        if let items = jsonResult["search_results"] as? NSArray {
                            
                            var type = String()
                            var roomType = String()
                            var price = String()
                            var name = String()
                            var guests = String()
                            var beds = String()
                            var bedrooms = String()
                            var bathrooms = String()
                            var publicAddress = String()
                            var id = String()
                            var propertyTypeImage = String()
                            var lat = Double()
                            var lon = Double()
                            var url = String()
                            

                            var location = CLLocationCoordinate2D()
                            
                            for item in items as [AnyObject]{
                                
                                if let listing = item["listing"] as? NSDictionary {
                                    
                                  
                                    url = listing["picture_url"] as! String
                                    lat = listing["lat"] as! Double
                                    lon = listing["lng"] as! Double
                                    id = "\(listing["id"] as AnyObject)"
                                    name = listing["name"] as! String
                                    type = listing["property_type"] as! String
                                    roomType = listing["room_type"] as! String
                                    bathrooms = "\(listing["bathrooms"] as AnyObject)"
                                    beds = "\(listing["beds"] as AnyObject)"
                                    bedrooms = "\(listing["bedrooms"] as AnyObject)"
                                    publicAddress = listing["public_address"] as! String
                                   
                                    location = CLLocationCoordinate2D(latitude: lat, longitude: lon)

                                    
                                    if let propertyId = listing["property_type_id"] as? Int {
                                        
                                        if propertyId == 1 {
                                            
                                            propertyTypeImage = "apartment-3.png"
                                        } else if propertyId == 2 {
                                            
                                            propertyTypeImage = "bighouse.png"
                                        } else if propertyId == 3 {
                                            
                                            propertyTypeImage = "bed_breakfast1-2.png"
                                        } else {
                                            
                                            propertyTypeImage = "lodging-2.png"
                                        }
                                        
                                    }

                                }
                                
                                if let pricing = item["pricing_quote"] as? NSDictionary {

                                    
                                   guests = "\(pricing["guests"] as AnyObject)"
                                        
                                        price = "\(pricing["localized_nightly_price"] as AnyObject) \(pricing["localized_currency"] as AnyObject)"
                                    
                                    
                                }

                                let annotation = CustomPointAnnotation()
                                
                                annotation.title = type
                                annotation.subtitle = price + " - " + roomType
                                annotation.coordinate = location
                                annotation.imageName = propertyTypeImage
                                annotation.placeId = id
                                annotation.roomType = roomType
                                annotation.placePublicAddress = publicAddress
                                annotation.placeBeds = beds
                                annotation.placeGuests = guests
                                annotation.placeBedrooms = bedrooms
                                annotation.placeBathrooms = bathrooms
                                annotation.placeTitle = name
                                annotation.placeType = type
                                annotation.placePrice = price
                                annotation.lat = lat
                                annotation.lon = lon
                                annotation.url = url
                                
                                
                                self.mapView.addAnnotation(annotation)
                                
                            }
                            
                            self.mapView.reloadInputViews()
                            
                        }
                        
                        
                        
                        
                        
                    } catch {
                        
                        
                    }
                    
                    
                }
            }
            
        }
        task.resume()

    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let button: UIButton = UIButton.init(type: UIButtonType.detailDisclosure)
        
        button.addTarget(self, action: #selector(MapViewController.moreInfo), for: UIControlEvents.touchUpInside)
        
        let customAnnotation = annotation as! CustomPointAnnotation
        
        annotationView?.rightCalloutAccessoryView = button
        annotationView?.image = UIImage(named: customAnnotation.imageName)
        
        return annotationView
    }
    
    //Helper Methods
    
    func moreInfo () {
        
        performSegue(withIdentifier: "showDetailFromMap", sender: self)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        
        setMap(lat: userLocation.coordinate.latitude, lon: userLocation.coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(userLocation) {(placemarks, error) in
            
            if error != nil {
                
                print(error)
            } else {
                
                if let placemark = placemarks?[0] {
                    
                    
                    
                    if placemark.locality != nil {
                        
                        self.city = placemark.locality!
                        
                        if self.city != self.city2 {
                            
                            self.city2 = placemark.locality!
                            self.getPlacesLocations(city: placemark.locality!)
                        }
                        
                    }
                    
  
                }
            }
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showDetailFromMap" {
            
            let detailVC = segue.destination as! DetailViewController
            
            //let senderPin = sender as! MKAnnotationView
            
            let selectedPin = mapView.selectedAnnotations[0] as! CustomPointAnnotation

           // detailVC.image =
            
            detailVC.placeTitle = selectedPin.placeTitle!
            detailVC.placeType = selectedPin.placeType!
            detailVC.placePrice = selectedPin.placePrice!
            detailVC.roomType = selectedPin.roomType!
            
            detailVC.placeBedrooms = selectedPin.placeBedrooms!
            detailVC.placeBathrooms = selectedPin.placeBathrooms!
            detailVC.placeBeds = selectedPin.placeBeds!
            detailVC.placeGuests = selectedPin.placeGuests!
            
            detailVC.lat = selectedPin.lat!
            detailVC.lon = selectedPin.lon!
            
            detailVC.id = selectedPin.placeId!
            
            detailVC.placePublicAddress = selectedPin.placePublicAddress!
            
            detailVC.url = selectedPin.url!
            
           

            
        }
    }
    

}
