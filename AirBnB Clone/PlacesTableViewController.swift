//
//  PlacesTableViewController.swift
//  AirBnB Clone
//
//  Created by orlando arzola on 14.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    
    var placeNames = [String]()
    var placeTypes = [String]()
    var placePrices = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://api.airbnb.com/v2/search_results?client_id=3092nxybyb0otqw18e8nh5nty")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            
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
                  
                                    self.placeNames.append(listing["name"] as! String)
                                    self.placeTypes.append(listing["property_type"] as! String)
                                    
   
                                }
                                
                                if let pricing = item["pricing_quote"] as? NSDictionary {
                                    
                                    self.placePrices.append("\(pricing["nightly_price"] as AnyObject) \(pricing["listing_currency"] as AnyObject)")
                                }
                            }
                        }
                        
                        self.tableView.reloadData()
                        /*
                        if let description = ((jsonResult["weather"] as? AnyObject)?[0] as? AnyObject)?["description"] as? String {
                         
                            DispatchQueue.main.sync(execute: {
                         
                         
                            })
                        }
 
 */
                        
                        
                    } catch {
                        
                        
                    }
                    
                    
                }
            }
            
        }
        task.resume()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
