//
//  Ellipse.swift
//  Primitives
//
//  Created by Julien Saad on 2016-11-06.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import Foundation

class Ellipse: NSObject {
    var x: UInt32
    var y: UInt32
    var radius: UInt32
    
    init(x: UInt32, y: UInt32, radius: UInt32) {
        self.x = x
        self.y = y
        self.radius = radius
    }
    
    override var description: String {
        return "(\(self.x),\(self.y)) : r: \(self.radius)"
    }
}
