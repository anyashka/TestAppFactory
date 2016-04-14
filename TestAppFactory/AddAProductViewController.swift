//
//  AddAProductViewController.swift
//  TestAppFactory
//
//  Created by Anna-Maria Shkarlinska on 13/04/16.
//  Copyright © 2016 Anna-Maria Shkarlinska. All rights reserved.
//

import UIKit
import Alamofire


class AddAProductViewController: UIViewController, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameOfProduct: UITextField!
    @IBOutlet weak var qrCode: UITextField!
    @IBOutlet weak var descOfProduct: UITextField!
    @IBOutlet weak var frontPic: UIImageView!
    @IBOutlet weak var backPic: UIImageView!
    @IBOutlet weak var eanPic: UIImageView!
    
    var whichButtonWasPressed: Int! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let headers = [
        "x-auth-email": "t8@refactory.net",
        "x-auth-token": "0fb5ea846d146890931b3cd71f962f1565e57ea1"
    ]
    

    
    func uploadProduct(productName: String, qrCode: String, optionalDescription: String?, frontImage: UIImage,backImage: UIImage,eanImage: UIImage) {
        let fileManager = NSFileManager.defaultManager()
        let frontPicture = UIImageJPEGRepresentation(frontImage, 0.5)!
        let backPicture = UIImageJPEGRepresentation(backImage, 0.5)!
        let eanPicture = UIImageJPEGRepresentation(eanImage, 0.5)!
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths.first
        let frontPath = (documentDirectory! as NSString).stringByAppendingPathComponent("temp1.jpg")
        let backPath = (documentDirectory! as NSString).stringByAppendingPathComponent("temp2.jpg")
        let eanPath = (documentDirectory! as NSString).stringByAppendingPathComponent("temp3.jpg")
        
        
        if frontPicture.writeToFile(frontPath, atomically: false) && backPicture.writeToFile(backPath, atomically: false) && eanPicture.writeToFile(eanPath, atomically: false){
            let frontFileURL = NSURL(fileURLWithPath: frontPath)
            let backURL = NSURL(fileURLWithPath: backPath)
            let eanURL = NSURL(fileURLWithPath: eanPath)
            let uploadURL = "http://rf-test-api.westeurope.cloudapp.azure.com/api/products"
            Alamofire.upload(.POST, uploadURL,
                             headers: headers,
                             multipartFormData: {  multipartFormData in
                                multipartFormData.appendBodyPart(fileURL: frontFileURL, name: "front_photo")
                                multipartFormData.appendBodyPart(fileURL: backURL, name: "back_photo")
                                multipartFormData.appendBodyPart(fileURL: eanURL, name: "ean_photo")
                                multipartFormData.appendBodyPart(data: productName.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "name")
                                multipartFormData.appendBodyPart(data: qrCode.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "qr_value")
                                if let description = optionalDescription {
                                    multipartFormData.appendBodyPart(data: description.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "description")
                                }
                },
                             encodingMemoryThreshold: 2*1024*1024,
                             encodingCompletion: { encodingResult in
                                switch encodingResult {
                                case .Success(let upload, _, _):
                                    upload.responseData { response -> Void in
                                        
                                        let statusCode = response.response?.statusCode
                                        if statusCode == 200 {
                                            print("yes")
         
                                        } else {
                                            print("Failed sending a product, reason: \(response.response)")
                                            if let response = response.response {
                                               print("\(response.statusCode)")
                                            } else {
                                                print("Please check your internet connection.")
                                            }
                                        }
                                        do {
                                            try fileManager.removeItemAtPath(frontPath)
                                            try fileManager.removeItemAtPath(backPath)
                                            try fileManager.removeItemAtPath(eanPath)
                                        } catch {
                                            
                                        }
                                        
                                    }
                                case .Failure(let encodingError):
                                    print("error \(encodingError)")
                                }
                                
            })
        } else {
            print("Could not write temp file")
        }
    }
    
    @IBAction func addPicture(sender: UIButton) {
        
        let button = sender as UIButton
        whichButtonWasPressed = button.tag
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickerController.allowsEditing = true
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image:UIImage, editingInfo: [String : AnyObject]?){
        self.dismissViewControllerAnimated(true, completion: nil)
        switch whichButtonWasPressed {
        case 0:
            self.frontPic.image = image
        case 1:
            self.backPic.image = image
        case 2:
            self.eanPic.image = image
        default:
            print("Image won't be saved")
        }
      
        
}


    
    
    @IBAction func saveProduct(sender: AnyObject) {
        guard let nameText = self.nameOfProduct.text where 2...128 ~= nameText.characters.count   else {
        showAlertWithTitle("Error", message: "You should write a name, which contains from 2 to 128 characters")
            return
        }
        
        guard let qrText = self.qrCode.text where 2...255 ~= qrText.characters.count else {
             showAlertWithTitle("Error", message: "You should write a QRCode, which contains from 2 to 255 characters")
            return
        }
        
        guard frontPic.image != nil && backPic.image != nil && eanPic.image != nil else{
             showAlertWithTitle("Error", message: "You should add all photos")
            return
        }
        
        if let descText = self.descOfProduct.text{
            uploadProduct(nameText, qrCode: qrText, optionalDescription: descText, frontImage: frontPic.image!, backImage: backPic.image!, eanImage: eanPic.image!)
        } else{
             uploadProduct(nameText, qrCode: qrText, optionalDescription: nil, frontImage: frontPic.image!, backImage: backPic.image!, eanImage: eanPic.image!)
        }

    }
    
    
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alertVC.addAction(okAction)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.presentViewController(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
