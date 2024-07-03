//
//  SKTexture.swift
//  ZellTob
//
//  Created by Foundation-012 on 02/07/24.
//

import SpriteKit
import ImageIO

extension SKTexture {
    static func texturesFromGif(named gifName: String) -> [SKTexture]? {
        guard let url = Bundle.main.url(forResource: gifName, withExtension: "gif"),
              let data = try? Data(contentsOf: url),
              let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("Could not load GIF named \(gifName)")
            return nil
        }
        
        var textures = [SKTexture]()
        let count = CGImageSourceGetCount(source)
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let texture = SKTexture(cgImage: cgImage)
                textures.append(texture)
            }
        }
        return textures
    }
}
