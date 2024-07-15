//
//  HomeViewController.swift
//  ZellTob
//
//  Created by Foundation-013 on 03/07/24.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var sound: UIButton!
    var isMute = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushToCard), name: Notification.Name("PushToCard"), object: nil)


        // Do any additional setup after loading the view.
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
    
    
    @objc func pushToCard() {
        performSegue(withIdentifier: "gotoCard", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
