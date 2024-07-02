//
//  GameSceneViewController.swift
//  ZellTob
//
//  Created by Foundation-012 on 01/07/24.
//

import Foundation
import UIKit
import SpriteKit

class GameSceneViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView(frame: view.bounds)
        view.addSubview(skView)
        
        let scene = GameScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
    }
}
