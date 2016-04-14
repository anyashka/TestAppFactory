//
//  ProductsTableViewController.swift
//  TestAppFactory
//
//  Created by Anna-Maria Shkarlinska on 13/04/16.
//  Copyright © 2016 Anna-Maria Shkarlinska. All rights reserved.
//

import UIKit
import Alamofire
class ProductsTableViewController: UITableViewController {
    
    var products : [Product] = [
    
//   Product(name: "test name", qrCode: "jhsdj7373", description: "hey"),
//    Product(name: "second test name", qrCode: "kfkfksdj7373", description: "you")
    ]
    
   // var products = [testProd, anotherTestProduct]
    
    
    
    let headers = [
    "cache-control": "no-cache" ,
    "content-type": "application/json",
    "x-auth-email": "t8@refactory.net",
    "x-auth-token": "0fb5ea846d146890931b3cd71f962f1565e57ea1"
    ]
    
    func fetchProducts(){
        let addres = "http://rf-test-api.westeurope.cloudapp.azure.com/api/products"
        Alamofire.request(.GET, addres, parameters: nil, encoding: .URL, headers: headers)
            .validate(statusCode: 200..<201)
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching products: \(response.result.error)")
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: AnyObject],
                    results = responseJSON["elements"] as? [AnyObject] else{
                        return
                }
                self.parseJSON(results)

        }
    }
    
    func parseJSON(elements: [AnyObject]){
        for product in elements{
            let id = product.valueForKey("id") as! String
            let name = product.valueForKey("name") as! String
            let qrCode = product.valueForKey("qr_value") as! String
            let frontPic = product.valueForKey("front_photo_path") as! String
            let backPic = product.valueForKey("back_photo_path") as! String
            let eanPic = product.valueForKey("ean_photo_path") as! String
            if let desc = product.valueForKey("description") as? String{
                products.append(Product(id: id, name: name, qrCode: qrCode, description: desc, frontPhoto: frontPic, backPhoto: backPic, eanPhoto: eanPic))
            }else{
                products.append(Product(id: id, name: name, qrCode: qrCode, description: nil, frontPhoto: frontPic, backPhoto: backPic, eanPhoto: eanPic))
            }
        
        }
        self.tableView.reloadData()

    }
    
    
    override func viewWillAppear(animated: Bool) {
        products.removeAll()
        fetchProducts()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }
    

     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("Product Cell", forIndexPath: indexPath)
     let element = products[indexPath.row]
        
        cell.textLabel!.text = element.name as String
        if (element.description) != nil{
            cell.detailTextLabel!.text = element.description! as String}

        return cell
     }

    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        
        if segue!.identifier == "toProduct"{
            
            let detailViewController:DetailViewController = segue!.destinationViewController as! DetailViewController
            detailViewController.data =  products[self.tableView.indexPathForSelectedRow!.row] as Product
            
        }
        
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }    
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
