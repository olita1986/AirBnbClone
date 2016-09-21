//
//  FavouritePlacesTableViewController.swift
//  AirBnB Clone
//
//  Created by orlando arzola on 20.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit
import Parse

class FavouritePlacesTableViewController: UITableViewController {
    
    var placesArray = [PFObject]()
    
    var image = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Getting the favorite places from localstorage
        
        self.title = "Favourite Places"
        
        let query = PFQuery(className: "Places")
        query.fromLocalDatastore()
        query.whereKey("userId", equalTo: FBSDKAccessToken.current().userID)
        
        query.findObjectsInBackground().continue ({ ( task: BFTask) -> Any? in
            if let error = task.error {
                print("Error: \(error)")
                return task
            }
            
            for place in task.result! {
                
                if let place = place as? PFObject {
                    
                    self.placesArray.append(place)
                    
                    //place.unpinInBackground()
                    
                    
                }
            }
            
            print(task.result?.count)
            
            DispatchQueue.main.async() { () -> Void in
                
                self.tableView.reloadData()
            }
            return task
        })
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
        return placesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlacesTableViewCell

        // Configure the cell...
        
        
        cell.placePriceLabel.text = placesArray[indexPath.row].object(forKey: "placePrice") as? String
        cell.placeTypeLabel.text = placesArray[indexPath.row].object(forKey: "placeType") as? String
        cell.placeTitleLabel.text = placesArray[indexPath.row].object(forKey: "placeName") as? String
        
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        if documentPath.count > 0 {
            
            let documentDirectory = documentPath[0]
            
            let restorePath = documentDirectory + "/" + (placesArray[indexPath.row].object(forKey: "placeId") as? String)! + ".png"
            
            print(restorePath)
            
            image.append(UIImage(contentsOfFile: restorePath)!)
            
            cell.placeImageView.image = UIImage(contentsOfFile: restorePath)
            
            
            
        }
        
       /*
        if let placePhoto = placesArray[indexPath.row].object(forKey: "imageFile") as? PFFile {
            
            placePhoto.getDataInBackground(block: { (data, error) in
                if error != nil {
                    
                    print(error)
                } else {
                    
                    if let imageData = data {
                        
                        if let downloadedImage = UIImage(data: imageData) {
                            
                            cell.placeImageView.image = downloadedImage
                        }
                    }
                }
            })
        }
 */
 


        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let indexPath: IndexPath = tableView.indexPathForSelectedRow!
        
        print(indexPath.row)
        
        
        
        let detailVC = segue.destination as! DetailViewController
        
        detailVC.image = image[indexPath.row]
        
        detailVC.placeTitle = (placesArray[indexPath.row].object(forKey: "placeName") as? String)!
        detailVC.placeType = (placesArray[indexPath.row].object(forKey: "placeType") as? String)!
        detailVC.placePrice = (placesArray[indexPath.row].object(forKey: "placePrice") as? String)!
        detailVC.roomType = (placesArray[indexPath.row].object(forKey: "roomType") as? String)!
        
        detailVC.placeBedrooms = (placesArray[indexPath.row].object(forKey: "bedrooms") as? String)!
        detailVC.placeBathrooms = (placesArray[indexPath.row].object(forKey: "bathrooms") as? String)!
        detailVC.placeBeds = (placesArray[indexPath.row].object(forKey: "beds") as? String)!
        detailVC.placeGuests = (placesArray[indexPath.row].object(forKey: "guests") as? String)!
        
        detailVC.lat = (placesArray[indexPath.row].object(forKey: "location") as! PFGeoPoint).latitude
        detailVC.lon = (placesArray[indexPath.row].object(forKey: "location") as! PFGeoPoint).longitude
        
        detailVC.id = (placesArray[indexPath.row].object(forKey: "placeId") as? String)!
        
        detailVC.placePublicAddress = (placesArray[indexPath.row].object(forKey: "publicAddress") as? String)!
        
        detailVC.placeDesc = (placesArray[indexPath.row].object(forKey: "description") as? String)!
        
        detailVC.senderView = 1
    }
    

}
