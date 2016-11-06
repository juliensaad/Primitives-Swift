//
//  ViewController.swift
//  Primitives
//
//  Created by Julien Saad on 2016-10-02.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var baseImageView: UIImageView = {
        let baseImageView = UIImageView(image: UIImage(named:"dg"))
        baseImageView.contentMode = .center
        return baseImageView
    }()
    
    private lazy var primitiveImageView: UIImageView = {
        let baseImageView = UIImageView(image: UIImage(named:"dg"))
        baseImageView.contentMode = .center
        return baseImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(baseImageView)
        view.addSubview(primitiveImageView)
        
        baseImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.centerY)
            make.width.equalTo(self.view)
        }
        
        primitiveImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.centerY)
            make.bottom.equalTo(self.view)
            make.width.equalTo(self.view)
        }
        
        primitiveImageView.layer.borderColor = UIColor.black.cgColor
        primitiveImageView.layer.borderWidth = 1
        
        let iterator = PrimitiveImageIterator(image: UIImage(named: "dg")!)
        DispatchQueue.global().async {
            for i in 0 ..< 2000 {
                iterator.step()
                DispatchQueue.main.async {
                    print(i)
                    var image = UIImage.imageFromBitmap(rawRepresentation: iterator.currentBitmap)
                    image = UIImage(cgImage: (image?.cgImage)!, scale: (image?.scale)!, orientation: UIImageOrientation.leftMirrored)
                    self.primitiveImageView.image = image
                }
            }
        }
        
       // primitiveImageView.image = UIImage.imageFromBitmap(rawRepresentation: iterator.currentBitmap)
        
        
//        var rawImage = RawRepresentationImage(pixels: pixels)
//        
//        _ = rawImage.addRandomCircle()
//        _ = rawImage.addRandomCircle()
//        _ = rawImage.addRandomCircle()
//        _ = rawImage.addRandomCircle()
//        
//        let generatedImage = UIImage.imageFromBitmap(rawRepresentation: rawImage)
//        primitiveImageView.image = generatedImage
        
        
        
//        for row in 0 ..< 50 {
//            for column in 0 ..< 50 {
//                print("\(row) \(column)")
//                rawImage.pixels[row][column] = RGBA32(aColor: UIColor.red)
//            }
//        }
//
//        _ = rawImage.addRandomSquare()
//        _ = rawImage.addRandomSquare()
//        _ = rawImage.addRandomSquare()
//        
//        primitiveImageView.image = UIImage.imageFromBitmap(rawRepresentation: rawImage)
        
//        primitiveImageView.image = primitiveImage.currentImage
//        
//        var score = primitiveImage.step(currentScore: Int.max)
//        primitiveImageView.image = primitiveImage.currentImage
        
        //DispatchQueue.global().async {
//            for i in 0 ..< 10 {
//                print(i)
//                score = primitiveImage.step(currentScore: score)
//               
//            }
        //}
        
     //   self.primitiveImageView.image = primitiveImage.currentImage
        
    }
    
}

