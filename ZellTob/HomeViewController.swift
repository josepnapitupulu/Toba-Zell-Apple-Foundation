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

        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
