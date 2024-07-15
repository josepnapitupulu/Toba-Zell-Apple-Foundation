//
//  PuzzleScene2.swift
//  ZellTob
//
//  Created by Foundation-013 on 04/07/24.
//

import UIKit
import SpriteKit
import ImageIO

class PuzzleScene2: SKScene {
    var selectedNodes = [SKSpriteNode]()
    var matchedPairs = 0
    let totalPairs = 8
    
    override func didMove(to view: SKView) {
        print("Scene loaded")
        shuffleImages()
        if UserDefaults.standard.bool(forKey: "isCard2Open") {
            transitionToPuzzleScene2()
        }
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
                let playSound = SKAction.playSoundFileNamed("klick.mp3", waitForCompletion: false)
                            self.run(playSound)
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
            
            // Buat animasi flip dengan scale dan fade
            let flipInAction = SKAction.scaleX(to: 0.0, duration: 0.25)
            let flipOutAction = SKAction.scaleX(to: 1.0, duration: 0.25)
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.25)
            let fadeInAction = SKAction.fadeIn(withDuration: 0.25)
            
            // Buat tindakan untuk mengganti node gambar dengan cover
            let revealAction = SKAction.run {
                coverNode.removeFromParent()
                imageNode.isHidden = false
            }
            
            // Jalankan urutan animasi flip, fade, dan penggantian gambar
            let flipSequence = SKAction.sequence([flipInAction, fadeOutAction, revealAction, fadeInAction, flipOutAction])
            coverNode.run(flipSequence)
            
            selectedNodes.append(imageNode)
            print("Selected nodes: \(selectedNodes.map { $0.name ?? "Unnamed" })")
            
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
            
            // Move to center
            let centerPoint = CGPoint(x: size.width / 42, y: size.height / 42)
            let moveToCenter = SKAction.move(to: centerPoint, duration: 0.3)
            
            let sequence = SKAction.sequence([moveToCenter, SKAction.run {
                self.createShatterEffect(for: firstNode)
                self.createShatterEffect(for: secondNode)
            }])
            
            firstNode.run(sequence)
            secondNode.run(sequence)
            
            let playSound = SKAction.sequence([
                    SKAction.wait(forDuration: 1.0),
                    SKAction.playSoundFileNamed("match.mp3", waitForCompletion: false)
                ])
                self.run(playSound)
            
            if matchedPairs == totalPairs {
                puzzleCompleted()
            }
        } else {
            // Gambar tidak cocok
            print("Nodes do not match")
            let shakeAction = SKAction.sequence([
                SKAction.moveBy(x: -10, y: 0, duration: 0.1),
                SKAction.moveBy(x: 20, y: 0, duration: 0.1),
                SKAction.moveBy(x: -10, y: 0, duration: 0.1)
            ])
            
            firstNode.run(shakeAction)
            secondNode.run(shakeAction)
            
            // Haptics for no match
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
            firstNode.run(SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.run {
                    let coverNode1 = SKSpriteNode(imageNamed: "tanya")
                    coverNode1.position = firstNode.position
                    coverNode1.name = "cover"
                    coverNode1.size = CGSize(width: 138, height: 232)
                    self.addChild(coverNode1)
                }
            ]))
            
            secondNode.run(SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.run {
                    let coverNode2 = SKSpriteNode(imageNamed: "tanya")
                    coverNode2.position = secondNode.position
                    coverNode2.name = "cover"
                    coverNode2.size = CGSize(width: 138, height: 232)
                    self.addChild(coverNode2)
                }
            ]))
        }
        
        selectedNodes.removeAll()
    }
    
    func puzzleCompleted() {
        print("Puzzle completed")
        if let cardNode = self.childNode(withName: "card_2") as? SKSpriteNode {
            displayCompletionImage(cardNode)
            
            // set card 1 open
            DataManager.openCard2()
            
            // Tambahkan waktu tunggu sebelum eksekusi logika berikutnya
            let wait = SKAction.wait(forDuration: 5.0) // Durasi jeda yang diinginkan
            let runBlock = SKAction.run {
                if let puzzleScene = SKScene(fileNamed: "PuzzleScene3") {
                    puzzleScene.scaleMode = .aspectFill
                    puzzleScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    let transition = SKTransition.reveal(with: .down, duration: 1)
                    self.view?.presentScene(puzzleScene, transition: transition)
                }
            }
            
            // Gabungkan aksi
            let sequence = SKAction.sequence([wait, runBlock])
            self.run(sequence)
        } else {
            displayCompletionGIF()
        }
    }
     
    func displayCompletionImage(_ cardNode: SKSpriteNode) {
        cardNode.zPosition = 8

        // Mengirim notifikasi untuk menghentikan musik latar
        NotificationCenter.default.post(name: NSNotification.Name("PauseBackgroundMusic"), object: nil)

        // Menjalankan SKAction untuk memutar suara
        let playSound = SKAction.playSoundFileNamed("complated2.mp3", waitForCompletion: true)
        self.run(playSound) {
            // Menunda selama 5 detik sebelum mengirim notifikasi untuk melanjutkan musik latar
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                NotificationCenter.default.post(name: NSNotification.Name("ResumeBackgroundMusic"), object: nil)
            }
        }

        // Mengatur skala x dan y secara terpisah untuk memperbesar tinggi lebih besar dari lebar
        let scaleXAction = SKAction.scaleX(to: cardNode.xScale * 1.4, duration: 0.5)
        let scaleYAction = SKAction.scaleY(to: cardNode.yScale * 1.8, duration: 0.5) // Perbesar lebih banyak pada sumbu y

        // Tambahkan rotasi dan perubahan warna untuk efek yang lebih ekstrem
        let rotateAction = SKAction.rotate(byAngle: .pi * 2, duration: 1.5)
        // let colorizeAction = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.5)

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
    
    func shuffleImages() {
       var imageNodes = [SKSpriteNode]()
       for i in 1...8 {
           if let imageNode = self.childNode(withName: "image_\(i)") as? SKSpriteNode {
               imageNodes.append(imageNode)
           }
       }
       
       guard imageNodes.count == 8 else {
           print("Tidak semua gambar ditemukan.")
           return
       }
       
       let positions = imageNodes.map { $0.position }
       let shuffledPositions = positions.shuffled()
       
       for (index, node) in imageNodes.enumerated() {
           node.position = shuffledPositions[index]
       }
       
       print("Images shuffled.")
   }
    
    func createShatterEffect(for node: SKSpriteNode) {
        let texture = node.texture!
        let size = node.size
        
        let rows = 10
        let cols = 10
        let pieceWidth = size.width / CGFloat(cols)
        let pieceHeight = size.height / CGFloat(rows)
        
        for row in 0..<rows {
            for col in 0..<cols {
                let x = CGFloat(col) * pieceWidth
                let y = CGFloat(row) * pieceHeight
                
                let rect = CGRect(x: x / size.width, y: y / size.height, width: pieceWidth / size.width, height: pieceHeight / size.height)
                let pieceTexture = SKTexture(rect: rect, in: texture)
                
                let pieceNode = SKSpriteNode(texture: pieceTexture)
                pieceNode.size = CGSize(width: pieceWidth, height: pieceHeight)
                pieceNode.position = CGPoint(x: node.position.x + x - size.width / 2 + pieceWidth / 2,
                                             y: node.position.y + y - size.height / 2 + pieceHeight / 2)
                pieceNode.zPosition = node.zPosition
                
                addChild(pieceNode)
                
                let moveX = CGFloat.random(in: -50...50)
                let moveY = CGFloat.random(in: -50...50)
                
                let moveAction = SKAction.moveBy(x: moveX, y: moveY, duration: 1.0)
                let fadeAction = SKAction.fadeOut(withDuration: 1.0)
                let removeAction = SKAction.removeFromParent()
                
                let sequence = SKAction.sequence([moveAction, fadeAction, removeAction])
                pieceNode.run(sequence)
            }
        }
        
        node.removeFromParent()
    }
    
    func transitionToPuzzleScene2() {
        if let puzzleScene = SKScene(fileNamed: "PuzzleScene3") {
            puzzleScene.scaleMode = .aspectFill
            puzzleScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.reveal(with: .down, duration: 1)
            self.view?.presentScene(puzzleScene, transition: transition)
        }
    }
}
