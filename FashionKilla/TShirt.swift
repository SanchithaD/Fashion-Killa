//
//  Shirt.swift
//  FashionKilla
//
//  Created by Sanchitha Dinesh on 2/3/24.
//

import Foundation

struct TShirt {
    var shirtName: String
    var leftSleeve: String
    var rightSleeve: String
    var torso: String
    init (shirtName: String){
        self.shirtName = shirtName
        self.leftSleeve = shirtName + " Left Sleeve"
        self.rightSleeve = shirtName + " Right Sleeve"
        self.torso = shirtName + " Torso"
    }
}
