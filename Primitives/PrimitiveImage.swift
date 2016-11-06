//
//  PrimitiveImage.swift
//  Primitives
//
//  Created by Julien Saad on 2016-10-02.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import UIKit

class PrimitiveImage {
    var objectiveImage: UIImage!
    var currentImage: UIImage!
    
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
        self.currentImage = UIImage.imageFromBitmap(rawRepresentation: RawRepresentationImage(pixels: pixels))
    }
   
    func step(currentScore: Int) -> Int {
        
//        var basePixelRepresentation = currentImage.pixelRepresentation()
//        var bestGuess = basePixelRepresentation
//        var bestScore: Int = currentScore
//        var bestLocalScore = Int.max
//        
//        var counter = 0
//        while (counter < 10) {
//            var newRepresentation = basePixelRepresentation
//            let boundsAffected = newRepresentation.addRandomCircle()
//            
//            let score = newRepresentation.compare(otherRepresentation: objectiveData, bounds: boundsAffected)
//            if score < bestScore {
//                bestScore = score
//                bestGuess = newRepresentation
//                break
//            }
//            
//            if score < bestLocalScore {
//                bestGuess = newRepresentation
//                bestLocalScore = score
//            }
//            counter = counter + 1
//        }
//        if bestScore < currentScore {
//            basePixelRepresentation = bestGuess
//            currentImage = UIImage.imageFromBitmap(rawRepresentation: basePixelRepresentation)
//        }
//        else {
//            print("No improvements in this iteration")
//        }
//        return bestScore
        return -1
    }
}
