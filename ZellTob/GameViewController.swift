//
//  GameViewController.swift
//  ZellTob
//
//  Created by Foundation-013 on 01/07/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func test() {
        // set TRUE to key card_1
        UserDefaults.standard.setValue(false, forKey: "card_1")
        UserDefaults.standard.setValue(false, forKey: "card_2")
        UserDefaults.standard.setValue(false, forKey: "card_3")
        UserDefaults.standard.setValue(false, forKey: "card_4")
        UserDefaults.standard.setValue(false, forKey: "card_5")
        
        
        // ambil value dari key card_1
        UserDefaults.standard.bool(forKey: "card_1")
    }
}
