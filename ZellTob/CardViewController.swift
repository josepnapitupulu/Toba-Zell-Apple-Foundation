//
//  CardViewController.swift
//  ZellTob
//
//  Created by Foundation-013 on 03/07/24.
//

import UIKit

class CardViewController: UIViewController {
    
    var selectedVideoNumber: Int = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var sound: UIButton!
    var isMute = false
    
    @IBOutlet weak var card1Button: UIButton!
    @IBOutlet weak var card2Button: UIButton!
    @IBOutlet weak var card3Button: UIButton!
    @IBOutlet weak var card4Button: UIButton!
    @IBOutlet weak var card5Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.setHidesBackButton(true, animated: true)

        // Do any additional setup after loading the view.
        
        if DataManager.isCard1Open == true {
            card1Button.isEnabled = true
        } else {
            card1Button.isEnabled = false
        }
        
        if DataManager.isCard2Open == true {
            card2Button.isEnabled = true
        } else {
            card2Button.isEnabled = false
        }
        
        if DataManager.isCard3Open == true {
            card3Button.isEnabled = true
        } else {
            card3Button.isEnabled = false
        }
        
        if DataManager.isCard4Open == true {
            card4Button.isEnabled = true
        } else {
            card4Button.isEnabled = false
        }
        
        if DataManager.isCard5Open == true {
            card5Button.isEnabled = true
        } else {
            card5Button.isEnabled = false
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
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let tag = sender.tag
        selectedVideoNumber = tag
        
        performSegue(withIdentifier: "gotoVideoDetail", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoVideoDetail"{
            if let vc = segue.destination as? VideoViewController{
                vc.videoNumber = selectedVideoNumber
            }
        }
    }

}
