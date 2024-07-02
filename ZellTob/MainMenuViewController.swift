//
//  MainMenuViewController.swift
//  ZellTob
//
//  Created by Foundation-007 on 01/07/24.
//

import UIKit
import AVFoundation

class MainMenuViewController: UIViewController {

    
    @IBOutlet weak var muteButton: UIButton!
    var isMute = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func changeMuteStatus(_ sender: Any) {
        if !isMute {
            muteButton.setImage(UIImage(systemName:"speaker.slash.circle.fill"), for: .normal)
            isMute = true
            appDelegate.music?.stop()
            
        }else{
            muteButton.setImage(UIImage(systemName: "speaker.circle.fill"), for: .normal)
            isMute = false
            appDelegate.music?.play()
        }
    }
    }
    
