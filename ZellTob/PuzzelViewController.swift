//
//  PuzzelViewController.swift
//  ZellTob
//
//  Created by Foundation-013 on 01/07/24.
//

import UIKit
import SpriteKit
import AVFoundation

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


class PuzzelViewController: UIViewController {

    var isMute = false
    
    @IBOutlet weak var sound: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(popBackToRoot), name: Notification.Name("GameDone"), object: nil)

//        self.navigationItem.setHidesBackButton(true, animated: true)
        
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
    
    override var prefersStatusBarHidden: Bool{
        return true
    } // Do any additional setup after loading the view.
    
    
    @objc func popBackToRoot() {
        navigationController?.popViewController(animated: true)
        
        NotificationCenter.default.post(name: Notification.Name("PushToCard"), object: nil)
    }
    
    @IBAction func buttonBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
