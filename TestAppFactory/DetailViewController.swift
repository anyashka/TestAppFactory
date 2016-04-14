//
//  DetailViewController.swift
//  TestAppFactory
//
//  Created by Anna-Maria Shkarlinska on 14/04/16.
//  Copyright © 2016 Anna-Maria Shkarlinska. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var data = Product?()
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var qrCode: UILabel!
    @IBOutlet weak var descriptionaOfProduct: UILabel?
    
    
    @IBOutlet weak var frontPhoto: UIImageView!
    @IBOutlet weak var backPhoto: UIImageView!
    @IBOutlet weak var eanPhoto: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if data != nil{
            name.text = data?.name
            qrCode.text = data?.qrCode
            if let descOfProduct = data?.description{
                descriptionaOfProduct?.text = descOfProduct
            } else{
                descriptionaOfProduct?.text = nil
            }
            let baseURL = "http://rf-test-api.westeurope.cloudapp.azure.com/"
            let frontURL = baseURL + data!.frontPhoto
            let backURL = baseURL + data!.backPhoto
            let eanURL = baseURL + data!.eanPhoto
            frontPhoto.image = UIImage(frontPhoto.imageFromUrl(frontURL))
            backPhoto.image = UIImage(backPhoto.imageFromUrl(backURL))
            eanPhoto.image = UIImage(eanPhoto.imageFromUrl(eanURL))

        }
    }
    
}

extension UIImageView {
    func imageFromUrl(urlString: String)  {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) {
                    (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                    if let imageData = data as NSData? {
                        self.image = UIImage(data: imageData)
                }
            }
        }
    }
}

