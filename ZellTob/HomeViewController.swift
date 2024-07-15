//
//  HomeViewController.swift
//  ZellTob
//
//  Created by Foundation-013 on 03/07/24.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var sound: UIButton!
    @IBOutlet weak var rulesImageView: UIImageView!
    
    var isMute = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var rulesCheckTimer: Timer?
    
    var backgroundView: UIView!
    var closeButton: UIButton!
    var isRulesImageHidden = false
    var hasShownRulesImageView = false // Menyimpan status apakah animasi sudah pernah dijalankan

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushToCard), name: Notification.Name("PushToCard"), object: nil)
        
        setupBackgroundView()
        setupCloseButton()
        
        updateRulesImageViewVisibility()
        startRulesCheckTimer()
        
        print("viewDidLoad - isCard1Open: \(UserDefaults.standard.bool(forKey: "isCard1Open"))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRulesImageViewVisibility()
        print("viewWillAppear - isCard1Open: \(UserDefaults.standard.bool(forKey: "isCard1Open"))")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopRulesCheckTimer()
        print("viewWillDisappear - isCard1Open: \(UserDefaults.standard.bool(forKey: "isCard1Open"))")
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
    
    func setupBackgroundView() {
        backgroundView = UIView(frame: self.view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.isHidden = true
        self.view.insertSubview(backgroundView, belowSubview: rulesImageView)
    }
    
    func setupCloseButton() {
        closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = UIColor.white
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeRulesImageView), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: rulesImageView.topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: rulesImageView.leadingAnchor, constant: 10),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func closeRulesImageView() {
        isRulesImageHidden = true
        animateRulesImageViewHide()
    }
    
    func updateRulesImageViewVisibility() {
        let isCard1Open = UserDefaults.standard.bool(forKey: "isCard1Open")
        let shouldHide = isCard1Open || isRulesImageHidden
        
        if shouldHide {
            animateRulesImageViewHide()
        } else {
            animateRulesImageViewShow()
        }
        
        print("updateRulesImageViewVisibility - isCard1Open: \(isCard1Open), isRulesImageHidden: \(isRulesImageHidden)")
    }
    
    func animateRulesImageViewShow() {
        if hasShownRulesImageView { // Jika animasi sudah pernah dijalankan, langsung tampilkan tanpa animasi
            rulesImageView.isHidden = false
            backgroundView.isHidden = false
            closeButton.isHidden = false
        } else { // Animasi fade-in pertama kali
            rulesImageView.isHidden = false
            backgroundView.isHidden = false
            closeButton.isHidden = false
            
            rulesImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            rulesImageView.alpha = 0
            
            UIView.animate(withDuration: 0.5, animations: {
                self.rulesImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.rulesImageView.alpha = 1.0
            }) { _ in
                self.hasShownRulesImageView = true // Tandai bahwa animasi sudah pernah dijalankan
            }
        }
    }
    
    func animateRulesImageViewHide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.rulesImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.rulesImageView.alpha = 0
        }) { _ in
            self.rulesImageView.isHidden = true
            self.backgroundView.isHidden = true
            self.closeButton.isHidden = true
        }
    }
    
    func startRulesCheckTimer() {
        rulesCheckTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkRulesVisibility), userInfo: nil, repeats: true)
    }
    
    func stopRulesCheckTimer() {
        rulesCheckTimer?.invalidate()
        rulesCheckTimer = nil
    }
    
    @objc func checkRulesVisibility() {
        updateRulesImageViewVisibility()
    }
    
    func toggleCard1OpenState() {
        let currentState = UserDefaults.standard.bool(forKey: "isCard1Open")
        UserDefaults.standard.set(!currentState, forKey: "isCard1Open")
        updateRulesImageViewVisibility()
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
