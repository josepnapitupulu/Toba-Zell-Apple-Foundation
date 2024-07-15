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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCardStatus), name: .cardStatusDidChange, object: nil)
                
        
//        self.navigationItem.setHidesBackButton(true, animated: true)

        // Do any additional setup after loading the view.
        
        setupCardButton(button: card1Button, isOpen: DataManager.isCard1Open)
        setupCardButton(button: card2Button, isOpen: DataManager.isCard2Open)
        setupCardButton(button: card3Button, isOpen: DataManager.isCard3Open)
        setupCardButton(button: card4Button, isOpen: DataManager.isCard4Open)
        setupCardButton(button: card5Button, isOpen: DataManager.isCard5Open)
        
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
    
    func setupCardButton(button: UIButton, isOpen: Bool) {
        if isOpen {
            button.isEnabled = true
            button.alpha = 1.0
            removeDarkOverlay(from: button)
        } else {
            button.isEnabled = false
            button.alpha = 1.0
            addDarkOverlay(to: button)
        }
    }
    
    func addDarkOverlay(to button: UIButton) {
        let overlay = UIView(frame: button.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.tag = 100 // Tag to identify the overlay view later
        overlay.isUserInteractionEnabled = false
        button.addSubview(overlay)
    }
    
    func removeDarkOverlay(from button: UIButton) {
        if let overlay = button.viewWithTag(100) {
            overlay.removeFromSuperview()
        }
    }
    
    @objc func updateCardStatus() {
        card1Button.isEnabled = DataManager.isCard1Open
        card2Button.isEnabled = DataManager.isCard2Open
        card3Button.isEnabled = DataManager.isCard3Open
        card4Button.isEnabled = DataManager.isCard4Open
        card5Button.isEnabled = DataManager.isCard5Open
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .cardStatusDidChange, object: nil)
    }
    
    @IBAction func onOffSound(_ sender: Any) {
        if !isMute {
            if let image = UIImage(systemName: "speaker.slash.circle")?.resized(to: CGSize(width: 47, height: 47)) {
                let tintedImage = image.withTintColor(UIColor(hex: "#384C28"), renderingMode: .alwaysOriginal)
                sound.setImage(tintedImage, for: .normal)
            }
            isMute = true
            appDelegate.music?.stop()
        } else {
            if let image = UIImage(systemName: "speaker.circle")?.resized(to: CGSize(width: 47, height: 47)) {
                let tintedImage = image.withTintColor(UIColor(hex: "#384C28"), renderingMode: .alwaysOriginal)
                sound.setImage(tintedImage, for: .normal)
            }
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

    @IBAction func backToHouse(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
