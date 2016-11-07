//
//  RawRepresentationImage.swift
//  Primitives
//
//  Created by Julien Saad on 2016-10-08.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import Foundation

struct RawRepresentationImage {
    
    var pixels: [[RGBA32]]
    
    init(pixels: [[RGBA32]]) {
        self.pixels = pixels
    }
    
    var width: Int {
        return pixels.count
    }
    
    var height: Int {
        return pixels.count > 0 ? pixels[0].count : 0
    }
    
    var singleArrayPixels: [RGBA32] {
        var singleArrayPixels = [RGBA32]()
        
        for row in 0 ..< width {
            for column in 0 ..< height {
                singleArrayPixels.append(pixels[row][column])
            }
        }
        return singleArrayPixels
    }
    
    func compare(otherRepresentation: RawRepresentationImage) -> Int {
        let otherPixels      = otherRepresentation.pixels
        let width            = otherPixels.count
        let currentPixels = pixels
        
        let modulo = Int(arc4random_uniform(50))
        var score = 0
        for row in 0 ..< width {
            for column in 0 ..< height {
                if ((row+column*width) % (800 + modulo)) == 0 {
                    score += otherPixels[row][column].difference(from: currentPixels[row][column], compareAlpha: false)
                }
            }
        }
        return score
    }
    
    func averageColor(minX: Int, maxX: Int, minY: Int, maxY: Int) -> RGBA32 {
        
        if minX == maxX || minY == maxY || minX > maxX || minY > maxY {
            return pixels[minX][minY]
        }
        
        var r: UInt = 0
        var g: UInt = 0
        var b: UInt = 0
        var count: Int = 0
        for row in minX ..< maxX {
            for column in minY ..< maxY {
                r += UInt(pixels[row][column].red)
                g += UInt(pixels[row][column].green)
                b += UInt(pixels[row][column].blue)
                count += 1
            }
        }
        
        return RGBA32(red: UInt8(Double(Int(r) / count)),
                      green: UInt8(Double(Int(g) / count)),
                      blue: UInt8(Double(Int(b) / count)),
                      alpha: 180)
    }
    
    mutating func addRandomCircle(usingTintForOriginalImage originalImage: RawRepresentationImage, iteration: Int) -> Ellipse {
        
        let radius = arc4random_uniform(UInt32(height / 2))
        let x = arc4random_uniform(UInt32(width))
        let y = arc4random_uniform(UInt32(height))
        
        let circle = Ellipse(x: x, y: y, radius: radius)
        addCircle(circle: circle, tintedWithImage: originalImage)
        
        return circle
    }
    
    mutating func addMutatedCircle(usingTintForOriginalImage originalImage: RawRepresentationImage, circle: Ellipse) -> Ellipse {
        
        let radius = Int(circle.radius) + randRange(lower: -5, upper: 5)
        
        let lowerBoundX = -Int(min(10, circle.x))
        let lowerBoundY = -Int(min(10, circle.y))
        let upperBoundX = UInt32(circle.x + 10) >= UInt32(width - 1) ? width - Int(circle.x) : 10
        let upperBoundY = UInt32(circle.y + 10) >= UInt32(height - 1) ? height - Int(circle.y) : 10

        //print("Past circle \(circle)")
        var x = Int(circle.x) + randRange(lower: lowerBoundX, upper: upperBoundX)
        var y = Int(circle.y) + randRange(lower: lowerBoundY, upper: upperBoundY)
        
        if x < 0 {
            x = 0
        }
        if y < 0 {
            y = 0
        }
        if y > height - 1 {
            y = height - 1
        }
        if x > width - 1 {
            x = width - 1
        }
        circle.x = UInt32(x)
        circle.y = UInt32(y)
        
        if radius < 5 {
            circle.radius = 5
        }
        else {
            circle.radius = UInt32(radius)
        }
        
        
        ///print("New circle \(circle)")
        addCircle(circle: circle, tintedWithImage: originalImage)
        
        return circle
    }
    
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    mutating func addCircle(circle: Ellipse, tintedWithImage image: RawRepresentationImage) {
        let color = RGBA32.randomGray(alpha: UInt8(randRange(lower: 128, upper: 255)))
//        let color = image.averageColor(minX: max(0, Int(circle.x) - Int(circle.radius)),
//                                       maxX: min(width - 1, Int(circle.x) + Int(circle.radius)),
//                                       minY: max(0, Int(circle.y) - Int(circle.radius)),
//                                       maxY: min(height - 1, Int(circle.y) + Int(circle.radius)))
        
        let dimmer: Int = Int(sqrt(Double(arc4random_uniform(8)))) + 1
        let adder: Int = Int(sqrt(Double(arc4random_uniform(8)))) + 1

        let radiusSquared = circle.radius * circle.radius
        for row in 0 ..< width {
            for column in 0 ..< height {
                let squareRow = Int(Int(row) - Int(circle.x)) * Int(Int(row) - Int(circle.x))
                let squareColumn = Int(Int(column) - Int(circle.y)) * Int(Int(column) - Int(circle.y))
                let distanceSquared = UInt32(squareRow * dimmer + squareColumn * adder)
                if distanceSquared <= radiusSquared {
                    let combinedColor = pixels[row][column] + color
                    pixels[row][column] = combinedColor
                }
            }
        }
    }
    
//    mutating func addRandomSquare(usingTintForOriginalImage originalImage: RawRepresentationImage, iteration: Int) -> Rect {
//        var radius = 0
//        if iteration < 10 {
//            radius = height / 3
//        }
//        else if iteration < 100 {
//            radius = height / 5
//        }
//        else if iteration < 200 {
//            radius = height / 10
//        }
//        else if iteration < 400 {
//            radius = height / 15
//        }
//        else if iteration < 600 {
//            radius = height / 20
//        }
//        else if iteration < 800 {
//            radius = height / 25
//        }
//        else if iteration < 1000 {
//            radius = height / 30
//        }
//        else if iteration < 1200 {
//            radius = height / 40
//        }
//        else {
//            radius = height / 50
//        }
//        
//        let side = radius
//        let x = Int(arc4random_uniform(UInt32(width)))
//        let y = Int(arc4random_uniform(UInt32(height)))
//        let color = originalImage.averageColor(minX: max(0, x - side), maxX: min(width - 1, x + side), minY: max(0, y - side), maxY: min(height - 1, y + side))
//        
//        //averageColor(minX: max(0, x - side), maxX: min(width - 1, x + side), minY: max(0, y - side), maxY: min(height - 1, y + side))
//        
//        //RGBA32(red: UInt8(arc4random_uniform(255)), green: UInt8(arc4random_uniform(255)), blue: UInt8(arc4random_uniform(255)), alpha: 128)//averageColor(minX: max(0, x - radius), maxX: min(width - 1, x + radius), minY: max(0, y - radius), maxY: min(height - 1, y + radius))
//        // print(color)
//        
//        
//        for row in x ..< min(width, x + side) {
//            for column in y ..< min(height, y + side) {
//                let combinedColor = pixels[row][column] + color
//                pixels[row][column] = combinedColor
//            }
//        }
//        
//        return Rect(minx: x, miny: y, maxx: min(width, x + side), maxy: min(height, y + side))
//    }
    
}

struct Rect {
    let minx: Int
    let miny: Int
    let maxx: Int
    let maxy: Int
}
