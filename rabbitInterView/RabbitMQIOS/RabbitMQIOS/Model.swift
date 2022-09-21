//
//  Model.swift
//  RabbitMQIOS
//
//  Created by Mac Mini 2021_1 on 21/09/2022.
//

import Foundation
import UIKit

struct Message {
    var id : String
    var message : String
}

extension UIAlertController {
    
    static func alertWarning(message : String) -> UIAlertController {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
}
