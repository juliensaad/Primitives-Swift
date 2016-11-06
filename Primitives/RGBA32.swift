//
//  RGBA32.swift
//  Primitives
//
//  Created by Julien Saad on 2016-10-08.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import UIKit

struct RGBA32: Equatable {
    var a: UInt8 = 0
    var r: UInt8 = 0
    var g: UInt8 = 0
    var b: UInt8 = 0
    
    var red: UInt8 {
        return r
    }
    
    var green: UInt8 {
        return g
    }
    
    var blue: UInt8 {
        return b
    }
    
    var alpha: UInt8 {
        return a
    }
    
    var redf: Float {
        return Float(red) / 255.0
    }
    
    var greenf: Float {
        return Float(green) / 255.0
    }
    
    var bluef: Float {
        return Float(blue) / 255.0
    }
    
    var alphaf: Float {
        return Float(alpha) / 255.0
    }
    
    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        r = red
        g = green
        b = blue
        a = alpha
    }
    
    init(aColor: UIColor) {
        r = aColor.redValue
        g = aColor.greenValue
        b = aColor.blueValue
        a = aColor.alphaValue
    }
    
    /* Returns the number of HEX differences between all colors */
    func difference(from otherColor: RGBA32, compareAlpha: Bool) -> Int {
        let redDiff = abs(Int(red) - Int(otherColor.red))
        let blueDiff = abs(Int(blue) - Int(otherColor.blue))
        let greenDiff = abs(Int(green) - Int(otherColor.green))
        let alphaDiff = abs(Int(alpha) - Int(otherColor.alpha))
        return redDiff + blueDiff + greenDiff + (compareAlpha ? alphaDiff : 0)
    }
    
    static func random() -> RGBA32 {
        let red = UInt8(arc4random_uniform(UInt32(UInt8.max)))
        let green = UInt8(arc4random_uniform(UInt32(UInt8.max)))
        let blue = UInt8(arc4random_uniform(UInt32(UInt8.max)))
        let alpha = UInt8(arc4random_uniform(UInt32(UInt8.max)))
        
        return RGBA32(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
    
    static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
        return lhs.a == rhs.a && lhs.b == rhs.b && lhs.g == rhs.g && lhs.r == rhs.r
    }
    
    static func +(background: RGBA32, foreground: RGBA32) -> RGBA32 {
        
        let outputRed = (foreground.redf * foreground.alphaf) + (background.redf * (1.0 - foreground.alphaf))
        let outputGreen = (foreground.greenf * foreground.alphaf) + (background.greenf * (1.0 - foreground.alphaf))
        let outputBlue = (foreground.bluef * foreground.alphaf) + (background.bluef * (1.0 - foreground.alphaf))
        
        return RGBA32(red: UInt8(outputRed * 255), green: UInt8(outputGreen * 255), blue: UInt8(outputBlue * 255), alpha: UInt8(255))
    }
    
}

extension RGBA32 : CustomStringConvertible {
    public var description: String {
        return String(format: "#%02X%02X%02X%02X", arguments: [red, green, blue, alpha])
    }
}
