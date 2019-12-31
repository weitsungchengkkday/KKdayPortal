//
//  UIImageExtension.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/31.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    public class func gifImageWithData(_ data: Data, duration: Int? = nil) -> UIImage? {
        guard let source: CGImageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source, duration: duration)
    }

    public class func gifImageWithURL(_ gifUrl: String, duration: Int? = nil) -> UIImage? {

        guard let bundleURL: URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }

        guard let imageData: Data = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }

        return gifImageWithData(imageData, duration: duration)
    }

    public class var imageRetinaString: String {

        let imageRetinaString: String
        switch Int(UIScreen.main.scale) {
        case let scale where scale == 2 || scale == 3:
            imageRetinaString = "@\(scale)x"

        default:
            imageRetinaString = ""
        }

        return imageRetinaString
    }

    public class func gifImageWithName(_ name: String, isUseImageRetinaString: Bool, duration: Int? = nil) -> UIImage? {

        var name: String = name
        if isUseImageRetinaString {
            name += imageRetinaString
        }

        guard let bundleURL: URL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }
        guard let imageData: Data = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gifImageWithData(imageData, duration: duration)
    }

    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay: Double = 0.1

        let cfProperties: CFDictionary? = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)

        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        
        if delayObject.doubleValue == 0.0 {

            let rawPoint: UnsafeMutableRawPointer = Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()
            let value: UnsafeRawPointer? = CFDictionaryGetValue(gifProperties, rawPoint)
            delayObject = unsafeBitCast(value, to: AnyObject.self)
        }

        delay = delayObject as! Double

        if delay < 0.1 {
            delay = 0.1
        }

        return delay
    }

    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a: Int? = a
        var b: Int? = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a != nil && b != nil {
            if (a! < b!) {
                let c: Int? = a
                a = b
                b = c
            }
        }

        var rest: Int
        while true {
            rest = a! % b!

            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }

    class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd: Int = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return gcd
    }

    class func animatedImageWithSource(_ source: CGImageSource, duration: Int? = nil) -> UIImage? {
        let count: Int = CGImageSourceGetCount(source)
        var images: [CGImage] = [CGImage]()
        var delays: [Int] = [Int]()

        for i in 0..<count {
            if let image: CGImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }

            let delaySeconds: Double = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        let gcd: Int = gcdForArray(delays)
        var frames: [UIImage] = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        let duration: Int = duration ?? {
            var sum: Int = 0

            for val: Int in delays {
                sum += val
            }

            return sum
        }()

        let animation: UIImage? = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)

        return animation
    }
}
