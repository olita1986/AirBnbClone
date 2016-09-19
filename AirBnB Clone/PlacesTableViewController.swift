//
//  PlacesTableViewController.swift
//  AirBnB Clone
//
//  Created by orlando arzola on 14.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    
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
        
        
        navigationController?.navigationBar.isTranslucent = false
        tabBarController?.tabBar.isTranslucent = false
        
        if FBSDKAccessToken.current() != nil {
            
            print("User is logged in")
        } else {
            
            performSegue(withIdentifier: "showLoginFromPlaces", sender: self)
        }

       // let url = URL(string: "https://api.airbnb.com/v2/search_results?client_id=3092nxybyb0otqw18e8nh5nty")!
        
       let url = URL(string:  "https://api.airbnb.com/v2/search_results?client_id=3092nxybyb0otqw18e8nh5nty&locale=en-US&currency=USD&_format=for_search_results_with_minimal_pricing&_limit=30&_offset=0&location=Bogota")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            if error != nil {
                
                print(error)
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        //print(" Esto es el nombre de la posada\((((jsonResult["search_results"] as? NSArray)?[0] as? NSDictionary)?["listing"] as? NSDictionary)?["name"] as! String)")
                        
                        
                        if let items = jsonResult["search_results"] as? NSArray {
                            
                            for item in items as [AnyObject]{
                                
                                if let listing = item["listing"] as? NSDictionary {
                                    
                                    //print("Esto es el Nombre de la Posada: \(listing["name"] as! String)")
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
                                    
   
                                }
                                
                                if let pricing = item["pricing_quote"] as? NSDictionary {
                                
                                    
                                    self.placeGuests.append("\(pricing["guests"] as AnyObject)")
                                    
                                    if let rate = pricing["rate"] as? NSDictionary {
                                        
                                        self.placePrices.append("\(rate["amount"] as AnyObject) \(rate["currency"] as AnyObject)")
                                    }
                                    
                                }
                            }
                            
                            self.tableView.reloadData()
                        }
                        
                        
                     
                        
                    } catch {
                        
                        
                    }
                    
                    
                }
            }
            
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            let url = URL(string: placePictures[indexPath.row])!
            
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    
                    print(error)
                } else {
                    
                    if let data = data {
                        
                        if let image = UIImage(data: data) {
                            
                            self.cache.setObject(image, forKey: indexPath.row as AnyObject)
                            
                            self.placeImages.append(image)
                            
                            DispatchQueue.main.async() { () -> Void in
                                
                                cell.placeImageView.image = image
                            }
                            
                        }
                    }
                }
                
            }
            
            task.resume()
            
        }
        
        

        
        
        

        return cell
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
        
 
 
    }
    

}
