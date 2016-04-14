//
//  Product.swift
//  TestAppFactory
//
//  Created by Anna-Maria Shkarlinska on 14/04/16.
//  Copyright © 2016 Anna-Maria Shkarlinska. All rights reserved.
//

import Foundation
import UIKit

class Product{
    var id: String
    var name: String
    var qrCode: String
    var description: String?
    var frontPhoto: String
    var backPhoto: String
    var eanPhoto: String
    
    init(id: String, name: String, qrCode: String, description: String?, frontPhoto: String, backPhoto: String, eanPhoto: String){
        self.id = id
        self.name = name
        self.qrCode = qrCode
        self.description = description
        self.frontPhoto = frontPhoto
        self.backPhoto = backPhoto
        self.eanPhoto = eanPhoto
    }
    
}
