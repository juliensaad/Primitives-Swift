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
        
        if minX == maxX && minY == maxY {
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
                      alpha: 255)
    }
    
    mutating func addRandomCircle(usingTintForOriginalImage originalImage: RawRepresentationImage, iteration: Int) -> Rect {
        
        var radius = 0
        if iteration < 10 {
            radius = height / 3
        }
        else if iteration < 100 {
            radius = height / 5
        }
        else if iteration < 200 {
            radius = height / 10
        }
        else if iteration < 400 {
            radius = height / 15
        }
        else if iteration < 600 {
            radius = height / 20
        }
        else if iteration < 800 {
            radius = height / 25
        }
        else if iteration < 1000 {
            radius = height / 30
        }
        else if iteration < 1200 {
            radius = height / 40
        }
        else {
            radius = height / 50
        }
        let x = Int(arc4random_uniform(UInt32(width)))
        let y = Int(arc4random_uniform(UInt32(height)))
        
        let dimmer: Int = Int(sqrt(Double(arc4random_uniform(8)))) + 1
        let adder: Int = Int(sqrt(Double(arc4random_uniform(8)))) + 1
        
        let color = originalImage.averageColor(minX: max(0, x - radius), maxX: min(width - 1, x + radius), minY: max(0, y - radius), maxY: min(height - 1, y + radius))
  
        let radiusSquared = radius * radius
        for row in 0 ..< width {
            for column in 0 ..< height {
                let squareRow = Int(row - x) * Int(row - x)
                let squareColumn = Int(column - y) * Int(column - y)
                let distanceSquared = squareRow / dimmer + squareColumn / adder
                if distanceSquared <= radiusSquared {
                    let combinedColor = pixels[row][column] + color
                    pixels[row][column] = combinedColor
                }
            }
        }
        
        return Rect(minx: max(0, x - radius), miny: max(0,y - radius), maxx: min(width, x + radius), maxy: min(height, y + radius))
    }
    
    mutating func addRandomSquare(usingTintForOriginalImage originalImage: RawRepresentationImage, iteration: Int) -> Rect {
        var radius = 0
        if iteration < 10 {
            radius = height / 3
        }
        else if iteration < 100 {
            radius = height / 5
        }
        else if iteration < 200 {
            radius = height / 10
        }
        else if iteration < 400 {
            radius = height / 15
        }
        else if iteration < 600 {
            radius = height / 20
        }
        else if iteration < 800 {
            radius = height / 25
        }
        else if iteration < 1000 {
            radius = height / 30
        }
        else if iteration < 1200 {
            radius = height / 40
        }
        else {
            radius = height / 50
        }
        
        let side = radius
        let x = Int(arc4random_uniform(UInt32(width)))
        let y = Int(arc4random_uniform(UInt32(height)))
        let color = originalImage.averageColor(minX: max(0, x - side), maxX: min(width - 1, x + side), minY: max(0, y - side), maxY: min(height - 1, y + side))
        
        //averageColor(minX: max(0, x - side), maxX: min(width - 1, x + side), minY: max(0, y - side), maxY: min(height - 1, y + side))
        
        //RGBA32(red: UInt8(arc4random_uniform(255)), green: UInt8(arc4random_uniform(255)), blue: UInt8(arc4random_uniform(255)), alpha: 128)//averageColor(minX: max(0, x - radius), maxX: min(width - 1, x + radius), minY: max(0, y - radius), maxY: min(height - 1, y + radius))
        // print(color)
        
        
        for row in x ..< min(width, x + side) {
            for column in y ..< min(height, y + side) {
                let combinedColor = pixels[row][column] + color
                pixels[row][column] = combinedColor
            }
        }
        
        return Rect(minx: x, miny: y, maxx: min(width, x + side), maxy: min(height, y + side))
    }
    
}

struct Rect {
    let minx: Int
    let miny: Int
    let maxx: Int
    let maxy: Int
}
