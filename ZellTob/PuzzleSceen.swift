import UIKit
import SpriteKit
import ImageIO

class PuzzleSceen: SKScene {
    
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
        displayCompletionGIF()
    }
    
    func displayCompletionGIF() {
        guard Bundle.main.url(forResource: "Congrats", withExtension: "gif") != nil else {
            print("GIF file not found")
            return
        }
        
        let gifTexture = SKTexture(imageNamed: "Congrats.gif")
        let gifNode = SKSpriteNode(texture: gifTexture)
        let xOffset: CGFloat = 50  // Atur offset horizontal dari sebelah kiri
            let yOffset: CGFloat = 100 // Atur offset vertikal dari tengah layar
            gifNode.position = CGPoint(x: xOffset, y: self.size.height / 2 - yOffset)
        gifNode.size = self.size
        
        self.addChild(gifNode)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            gifNode.removeFromParent()
        }
    }
}
