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
        
        var iterationCount = 0
        while (bestScore == initialScore) {
            var newRepresentation = baseBitmap
            _ = newRepresentation.addRandomCircle(usingTintForOriginalImage: objectiveData, iteration:stepCount)
            
            let score = newRepresentation.compare(otherRepresentation: objectiveData)
            
            if score < bestScore {
                bestGuess = newRepresentation
                bestScore = score
            }
            iterationCount += 1
        }
        stepCount += 1
        self.currentBitmap = bestGuess
    }
}
