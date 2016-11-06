//
//  UIImage+Additions.swift
//  Primitives
//
//  Created by Julien Saad on 2016-10-02.
//  Copyright © 2016 Julien Saad. All rights reserved.
//

import UIKit

extension UIImage {
    
    // Returns an array of pixels representing the image
    func pixelRepresentation() -> RawRepresentationImage {
 
        let provider = cgImage!.dataProvider
        let providerData = provider!.data
        let data = CFDataGetBytePtr(providerData)!
        
        let numberOfComponents = 4
        var pixels = [[RGBA32]]()
        for row in 0 ..< Int(size.width) {
            pixels.append([RGBA32]())
            for column in 0 ..< Int(size.height) {
                let pixelIndex = (Int(size.width) * column + row) * numberOfComponents
                let r = data[pixelIndex]
                let g = data[pixelIndex + 1]
                let b = data[pixelIndex + 2]
                let a = data[pixelIndex + 3]
                
                pixels[row].append(RGBA32(red: r, green: g, blue: b, alpha: a))
            }
        }
        return RawRepresentationImage(pixels: pixels)
    }
    
    func pixelBuffer() -> (UnsafeMutablePointer<RGBA32>?, Int, Int) {
        guard let inputCGImage = cgImage else {
            print("unable to get cgImage")
            return (nil, -1, -1)
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return (nil, -1, -1)
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            print("unable to get context data")
            return (nil, -1, -1)
        }
        
        return (buffer.bindMemory(to: RGBA32.self, capacity: width * height), width, height)
    }

    func averageColor() -> UIColor {
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext()
        
        let inputImage: CIImage
        if ciImage != nil {
            inputImage = ciImage!
        }
        else {
            inputImage = CIImage(cgImage: cgImage!)
        }
        
        let extent = inputImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
        let outputImage = filter.outputImage!
        let outputExtent = outputImage.extent
        assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)
        
        // Render to bitmap.
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        
        return UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: 1.0)
    }
    
    class func resized(image: UIImage, newSize: CGSize) -> UIImage {
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(newSize, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
    class func imageFromBitmap(rawRepresentation: RawRepresentationImage) -> UIImage? {
        assert(rawRepresentation.width > 0)
        
        assert(rawRepresentation.height > 0)
        
        let pixelDataSize = MemoryLayout<RGBA32>.size
        assert(pixelDataSize == 4)
        
        assert(rawRepresentation.singleArrayPixels.count == Int(rawRepresentation.width * rawRepresentation.height))
        
        let data: Data = rawRepresentation.singleArrayPixels.withUnsafeBufferPointer {
            return Data(buffer: $0)
        }
        
        let cfdata = NSData(data: data) as CFData
        let provider: CGDataProvider! = CGDataProvider(data: cfdata)
        if provider == nil {
            print("CGDataProvider is not supposed to be nil")
            return nil
        }
        let cgimage: CGImage! = CGImage(
            width: rawRepresentation.width,
            height: rawRepresentation.height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: rawRepresentation.width * pixelDataSize,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
            provider: provider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        )
        if cgimage == nil {
            print("CGImage is not supposed to be nil")
            return nil
        }
        return UIImage(cgImage: cgimage)
    }
}
