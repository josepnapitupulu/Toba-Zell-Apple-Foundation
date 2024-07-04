//
//  PuzzelViewController.swift
//  ZellTob
//
//  Created by Foundation-013 on 01/07/24.
//

import UIKit
import SpriteKit
import AVFoundation

class PuzzelViewController: UIViewController {

    var isMute = false
    
    @IBOutlet weak var sound: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: true)
        
        if let view = self.view as! SKView?{
            if let scene = SKScene(fileNamed: "PuzzleSceen"){
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            view.showsNodeCount = true
            view.showsFPS = true
        }
        
    }
    
    @IBAction func onOffSound(_ sender: Any) {
        if !isMute {
            sound.setImage(UIImage(systemName: "speaker.slash.circle.fill"), for: .normal)
            isMute = true
            appDelegate.music?.stop()
        }else{
            sound.setImage(UIImage(systemName: "speaker.circle.fill"), for: .normal)
            isMute = false
            appDelegate.music?.play()
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    } // Do any additional setup after loading the view.
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
