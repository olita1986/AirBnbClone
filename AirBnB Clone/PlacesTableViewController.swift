//
//  PlacesTableViewController.swift
//  AirBnB Clone
//
//  Created by orlando arzola on 14.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit
import MapKit


class PlacesTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    //var dictArray = [Dictionary]()
    
    var activityIndicator = UIActivityIndicatorView()
    
    var city = ""
    var city2 = "h"
    
    var locationManager = CLLocationManager()
    
    var placeLat = [Double]()
    var placeLon = [Double]()
    var placeNames = [String]()
    var placeGuests = [String]()
    var placeAddress = [String]()
    var placeBedrooms = [String]()
    var placeBathrooms = [String]()
    var placeBeds = [String]()
    var placeTypes = [String]()
    var roomTypes = [String]()
    var placePrices = [String]()
    var placePictures = [String]()
    var placeImages = [UIImage]()
    var placeIds = [String]()
    var cache =  NSCache<AnyObject, UIImage>()

    @IBAction func logOut(_ sender: AnyObject) {
        
        FBSDKLoginManager().logOut()

        performSegue(withIdentifier: "showLoginFromPlaces", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Refresh Control Set Up
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(PlacesTableViewController.updateLocation), for: UIControlEvents.valueChanged)
        
        //Location manager Set Up
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter =  10
        locationManager.startUpdatingLocation()
        
        
        navigationController?.navigationBar.isTranslucent = false
        tabBarController?.tabBar.isTranslucent = false
        
        
        // Checking if the user is logged in
        if FBSDKAccessToken.current() != nil {
            
            print("User is logged in")
            
        } else {
            
            performSegue(withIdentifier: "showLoginFromPlaces", sender: self)
        }

      
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        locationManager.startUpdatingLocation()
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLocation()  {
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    // getting the places from the AirBNB API
    func getPlaces (city: String) {
        
        activateIndicator()
        cache.removeAllObjects()
        placeImages.removeAll()
        placePictures.removeAll()
        placeLat.removeAll()
        placeLon.removeAll()
        placeIds.removeAll()
        placeNames.removeAll()
        placeTypes.removeAll()
        roomTypes.removeAll()
        placePictures.removeAll()
        placeBathrooms.removeAll()
        placeBeds.removeAll()
        placeBedrooms.removeAll()
        placeAddress.removeAll()
        placeGuests.removeAll()
        
        self.placePrices.removeAll()
        // Download info from AirBnB api
        let url = URL(string:  "https://api.airbnb.com/v2/search_results?client_id=3092nxybyb0otqw18e8nh5nty&locale=en-US&currency=USD&_format=for_search_results&_limit=30&_offset=0&location=" + city.replacingOccurrences(of: " ", with: "%20"))
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            var count = 0
            if error != nil {
                
                print(error)
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        
                        // Extracting the result count
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        if let result = jsonResult["metadata"] as? NSDictionary {
                            
                            if let pagination = result["pagination"] as? NSDictionary {
                                
                                if let resultCount = pagination["result_count"] as? Int {
                                    
                                    count = resultCount
                                }
                            }
                        }
                        
                        // Extracting jason data
                        
                        if let items = jsonResult["search_results"] as? NSArray {
                            
                            for item in items as [AnyObject]{
                                
                                
                                if let listing = item["listing"] as? NSDictionary {
                                
                                    
                                    
                                    self.placeLat.append(listing["lat"] as! Double )
                                    self.placeLon.append(listing["lng"] as! Double )
                                    self.placeIds.append("\(listing["id"] as AnyObject)")
                                    self.placeNames.append(listing["name"] as! String)
                                    self.placeTypes.append(listing["property_type"] as! String)
                                    self.roomTypes.append(listing["room_type"] as! String)
                                    self.placePictures.append(listing["picture_url"] as! String)
                                    self.placeBathrooms.append("\(listing["bathrooms"] as AnyObject)")
                                    self.placeBeds.append("\(listing["beds"] as AnyObject)")
                                    self.placeBedrooms.append("\(listing["bedrooms"] as AnyObject)")
                                    self.placeAddress.append(listing["public_address"] as! String)
                                    
                                    let url = URL(string: listing["picture_url"] as! String)!
                                    
                                    let request = NSMutableURLRequest(url: url)
                                    let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                        data, response, error in
                                        
                                        if error != nil {
                                            
                                            print(error)
                                        } else {
                                            
                                            if let data = data {
                                                
                                                if let image = UIImage(data: data) {
                                                        
                                                    self.placeImages.append(image)
                                                    
                                                    // When count places.count reaches count the reload
                                                    if self.placeImages.count == count {
                                                        
                                                        
                                                        
                                                        DispatchQueue.main.async() { () -> Void in
                                                            
                                                            self.tableView.isUserInteractionEnabled = true
                                                            self.activityIndicator.stopAnimating()
                                                            self.activityIndicator.isHidden = true
                                                            self.tableView.reloadData()
                                                        }
                                                        
                                                        
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        
                                    }
                                    
                                    task.resume()
                                    
                                   
                                }
                                
                                if let pricing = item["pricing_quote"] as? NSDictionary {
                                    
                                    
                                    self.placeGuests.append("\(pricing["guests"] as AnyObject)")
                                    
                                    self.placePrices.append("\(pricing["localized_nightly_price"] as AnyObject) \(pricing["localized_currency"] as AnyObject)")
                                    
                                    
                                    
                                    /*
                                     if let rate = pricing["rate"] as? NSDictionary {
                                     
                                     self.placePrices.append("\(rate["amount"] as AnyObject) \(rate["currency"] as AnyObject)")
                                     }
                                     */
                                    
                                }
                            }
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                    } catch {
                        
                        self.createAlert(title: "Atention!", message: "There are no places in this city")
                        DispatchQueue.main.async() { () -> Void in
                            
                            self.tableView.isUserInteractionEnabled = true
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            self.tableView.reloadData()
                        }
                    }
                    
                    
                    
                }
            }
            
            //UIApplication.shared.endIgnoringInteractionEvents()
            
            
        }
        task.resume()
        
        
        
    }
    
    // Location Manager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        
        print(city)
      // Getting the city where the user is located from geocoder
        
        CLGeocoder().reverseGeocodeLocation(userLocation) {(placemarks, error) in
            
            if error != nil {
                
                print(error)
            } else {
                
                if let placemark = placemarks?[0] {
                    
                    
                    
                    if placemark.locality != nil {
                        
                        
                        //print(placemark.locality!)
                        
                        self.city = placemark.locality!
                        
                        if self.city != self.city2 {
                            
                            
                            self.city2 = self.city
                            
                            print("this is" + " " + self.city2)
                            self.getPlaces(city: placemark.locality!)
                            
                        }
                        
                    }
                    
                    
                }
            }
        }
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return placeNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlacesTableViewCell

        // Configure the cell...
        
    
            
            cell.placeTitleLabel.text = placeNames[indexPath.row]
            cell.placeTypeLabel.text = placeTypes[indexPath.row]
            cell.placePriceLabel.text = placePrices[indexPath.row]
        
        if let image = cache.object(forKey: indexPath.row as AnyObject) {
            
             cell.placeImageView.image = image
            
        } else {
            

            self.cache.setObject(placeImages[indexPath.row], forKey: indexPath.row as AnyObject)

            
                
                cell.placeImageView.image = self.placeImages[indexPath.row]
           
            

        }
        
        

        
        
        

        return cell
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "viewDetails" {
            
        
            let indexPath: IndexPath = tableView.indexPathForSelectedRow!
            
            print(indexPath.row)
            
            
            
            let detailVC = segue.destination as! DetailViewController
            
            detailVC.image = placeImages[indexPath.row]

            detailVC.placeTitle = placeNames[indexPath.row]
            detailVC.placeType = placeTypes[indexPath.row]
            detailVC.placePrice = placePrices[indexPath.row]
            detailVC.roomType = roomTypes[indexPath.row]
        
            detailVC.placeBedrooms = placeBathrooms[indexPath.row]
            detailVC.placeBathrooms = placeBedrooms[indexPath.row]
            detailVC.placeBeds = placeBeds[indexPath.row]
            detailVC.placeGuests = placeGuests[indexPath.row]
            
            detailVC.lat = placeLat[indexPath.row]
            detailVC.lon = placeLon[indexPath.row]
            
            detailVC.id = placeIds[indexPath.row]

            detailVC.placePublicAddress = placeAddress[indexPath.row]
                
            detailVC.senderView = 2
        }
        
 
 
    }
    
    func createAlert (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func activateIndicator () {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = false
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        tableView.isUserInteractionEnabled = false
        
        //UIApplication.shared.beginIgnoringInteractionEvents()
    }
    

}
