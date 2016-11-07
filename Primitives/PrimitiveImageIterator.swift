//
//  PrimitiveImageIterator.swift
//  Primitives
//
//  Created by Julien Saad on 2016-10-08.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import UIKit


import UIKit

class PrimitiveImageIterator {
    var objectiveImage: UIImage!
    var currentBitmap: RawRepresentationImage!
    
    private lazy var objectiveData: RawRepresentationImage = {
        return self.objectiveImage.pixelRepresentation()
    }()
    
    var stepCount: Int = 0
    
    init(image: UIImage) {
        self.objectiveImage = image
        
        let baseColor = objectiveImage.averageColor()
        
        // Draw image with average color from other image
        var pixels = [[RGBA32]]()
        for row in 0 ..< Int(objectiveImage.size.width * objectiveImage.scale) {
            pixels.append([RGBA32]())
            for _ in 0 ..< Int(objectiveImage.size.height * objectiveImage.scale) {
                pixels[row].append(RGBA32(aColor: baseColor))
            }
        }
        self.currentBitmap = RawRepresentationImage(pixels: pixels)
    }
    
    func step() {
        var bestGuess = self.currentBitmap
        let baseBitmap = self.currentBitmap!
        var bestScore: Int = self.currentBitmap.compare(otherRepresentation: objectiveData)
        let initialScore = bestScore
        
        var bestCircle: Ellipse = Ellipse(x: 0, y: 0, radius: 0)
        
        var iterationCount = 0
        // Find an initial okay circle to add
        while bestScore == initialScore && iterationCount < 10 {
            var newRepresentation = baseBitmap
            let circle = newRepresentation.addRandomCircle(usingTintForOriginalImage: objectiveData, iteration:stepCount)
            
            let score = newRepresentation.compare(otherRepresentation: objectiveData)
            
            if score < bestScore {
                iterationCount = 0
                bestGuess = newRepresentation
                bestScore = score
                bestCircle = circle
                print("Randomly improved solution")
            }
            iterationCount += 1
        }
        
        print("Random circle : \(bestCircle)")
        var upgradeCount = 0
        var attempts = 0
        while upgradeCount < 50 {
            var newRepresentation = baseBitmap
            let circle = newRepresentation.addMutatedCircle(usingTintForOriginalImage: objectiveData, circle: bestCircle)
            
            let score = newRepresentation.compare(otherRepresentation: objectiveData)
            
            if score < bestScore {
                bestGuess = newRepresentation
                bestScore = score
                bestCircle = circle
                upgradeCount += 1
                print("Smart circle : \(bestCircle)")
                print("Smartly improved solution")
                attempts = 0
            }
            attempts += 1
        }
        
        
        stepCount += 1
        if bestScore < initialScore {
            print("Solution improved by \(initialScore - bestScore)");
            self.currentBitmap = bestGuess
        }
    }
}
