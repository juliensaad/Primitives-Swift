//
//  UIColor+Additions.swift
//  Primitives
//
//  Created by Julien Saad on 2016-10-08.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import UIKit

extension UIColor {
    var redValue: UInt8 {
        return UInt8(self.cgColor.components![0]*255)
    }

    var greenValue: UInt8 {
        return UInt8(self.cgColor.components![1]*255)
    }

    var blueValue: UInt8 {
        return UInt8(self.cgColor.components![2]*255)
    }

    var alphaValue: UInt8 {
        return UInt8(self.cgColor.components![3]*255)
    }
}
