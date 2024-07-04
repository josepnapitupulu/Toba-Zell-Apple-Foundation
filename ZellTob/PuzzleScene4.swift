//
//  PuzzleScene4.swift
//  ZellTob
//
//  Created by Foundation-012 on 04/07/24.
//

import UIKit
import SpriteKit
import ImageIO

class PuzzleScene4: SKScene {
    var selectedNodes = [SKSpriteNode]()
    var matchedPairs = 0
    let totalPairs = 10 // Sesuaikan dengan jumlah total pasangan gambar yang ada dalam puzzle
    
    override func didMove(to view: SKView) {
        // Tambahan konfigurasi jika diperlukan
        print("Scene loaded")
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            print("No touch detected")
            return
        }
        let location = touch.location(in: self)
        let touchedNodes = self.nodes(at: location)
        
        print("Touched nodes at location \(location): \(touchedNodes.map { $0.name ?? "Unnamed" })")
        
        for node in touchedNodes {
            if node.name == "cover" {
                print("Cover node touched: \(node)")
                flipTile(node as! SKSpriteNode)
                break // keluar dari loop setelah menemukan dan menangani node "cover"
            }
        }
    }
    
    func flipTile(_ coverNode: SKSpriteNode) {
        guard selectedNodes.count < 2 else {
            print("Already two nodes selected")
            return
        }
        
        let position = coverNode.position
        
        // Cari node gambar asli yang tersembunyi di bawah cover
        if let imageNode = self.nodes(at: position).first(where: { $0.name?.starts(with: "image") ?? false }) as? SKSpriteNode {
            print("Image node found: \(imageNode.name ?? "Unnamed")")
            imageNode.isHidden = false
            coverNode.removeFromParent() // Hapus gambar penutup
            
            selectedNodes.append(imageNode)
            print( "Selected nodes: \(selectedNodes.map { $0.name ?? "Unnamed" })")
            
            if selectedNodes.count == 2 {
                checkForMatch()
            }
        } else {
            print("No image node found under cover node")
        }
    }
    
    func checkForMatch() {
        guard selectedNodes.count == 2 else {
            print("Selected nodes count is not 2")
            return
        }
        
        let firstNode = selectedNodes[0]
        let secondNode = selectedNodes[1]
        
        print("Checking match for nodes: \(firstNode.name ?? "Unnamed"), \(secondNode.name ?? "Unnamed")")
        
        if firstNode.name == secondNode.name {
            // Gambar cocok
            print("Nodes match")
            matchedPairs += 1
            firstNode.run(SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.removeFromParent()
            ]))
            secondNode.run(SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.removeFromParent()
            ]))
            
            if matchedPairs == totalPairs {
                puzzleCompleted()
            }
        } else {
            // Gambar tidak cocok
            print("Nodes do not match")
            firstNode.run(SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.run {
                    let coverNode1 = SKSpriteNode(imageNamed: "tanya")
                    coverNode1.position = firstNode.position
                    coverNode1.name = "cover"
                    coverNode1.size = CGSize(width: 136.494, height: 215.634)
                    self.addChild(coverNode1)
                }
            ]))
            
            secondNode.run(SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.run {
                    let coverNode2 = SKSpriteNode(imageNamed: "tanya")
                    coverNode2.position = secondNode.position
                    coverNode2.name = "cover"
                    coverNode2.size = CGSize(width: 136.494, height: 215.634)
                    self.addChild(coverNode2)
                }
            ]))
        }
        
        selectedNodes.removeAll()
    }
    
    func puzzleCompleted() {
         print("Puzzle completed")
         if let cardNode = self.childNode(withName: "card_1") as? SKSpriteNode {
             displayCompletionImage(cardNode)
             
             // set card 1 open
             DataManager.openCard1()
             if let puzzleScene = SKScene(fileNamed: "PuzzleScene2"){
                 puzzleScene.scaleMode = .aspectFill
                 puzzleScene.anchorPoint = CGPoint(x: 0.5, y:0.5)
                 let transition = SKTransition.reveal(with: .down, duration: 1)
                 view?.presentScene(puzzleScene, transition: transition)
             }
         } else {
             displayCompletionGIF()
         }
     }
     
    func displayCompletionImage(_ cardNode: SKSpriteNode) {
        cardNode.zPosition = 10
        
        // Mengatur skala x dan y secara terpisah untuk memperbesar tinggi lebih besar dari lebar
        let scaleXAction = SKAction.scaleX(to: cardNode.xScale * 1.4, duration: 0.5)
        let scaleYAction = SKAction.scaleY(to: cardNode.yScale * 1.6, duration: 0.5) // Perbesar lebih banyak pada sumbu y
        
        // Tambahkan rotasi dan perubahan warna untuk efek yang lebih ekstrem
        let rotateAction = SKAction.rotate(byAngle: .pi * 2, duration: 1.5)
//        let colorizeAction = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.5)
        
        // Gabungkan semua aksi menjadi satu
        let groupAction = SKAction.group([scaleXAction, scaleYAction, rotateAction])
        
        cardNode.run(groupAction) {
            self.displayCompletionGIF()
        }
    }

    
    
    
    func displayCompletionGIF() {
        guard let textures = SKTexture.texturesFromGif(named: "Congrats") else {
            print("GIF file not found")
            return
        }
        
        let gifNode = SKSpriteNode(texture: textures.first)
        gifNode.position = CGPoint(x: self.size.width / 42, y: self.size.height / 27)
        gifNode.size = CGSize(width: 600, height: 600) // Atur ukuran sesuai kebutuhan
        gifNode.zPosition = 11 // Pastikan node berada di lapisan atas, di atas cardNode
        
        // Tambahkan animasi ekstrem
        gifNode.setScale(0.2)
        gifNode.alpha = 0.0
        
        let scaleAction = SKAction.scale(to: 1.0, duration: 2.0)
        let fadeInAction = SKAction.fadeIn(withDuration: 1.0)
        let rotateAction = SKAction.rotate(byAngle: .pi * 2, duration: 1.0)
        
        let groupAction = SKAction.group([scaleAction, fadeInAction, rotateAction])
        gifNode.run(groupAction)
        
        let animationAction = SKAction.animate(with: textures, timePerFrame: 0.1)
        let repeatAction = SKAction.repeatForever(animationAction)
        
        gifNode.run(repeatAction)
        self.addChild(gifNode)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            gifNode.removeFromParent()
//        }
    }
}
