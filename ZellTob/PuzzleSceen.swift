import UIKit
import SpriteKit

class PuzzleSceen: SKScene {
    
    var selectedNodes = [SKSpriteNode]()
    
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
            firstNode.run(SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.removeFromParent()
            ]))
            secondNode.run(SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.removeFromParent()
            ]))
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
}
