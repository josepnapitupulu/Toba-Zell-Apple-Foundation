//
//  VideoViewController.swift
//  ZellTob
//
//  Created by Foundation-013 on 03/07/24.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {

    @IBOutlet weak var pausePlayButton: UIButton!
    var playerVideo: AVPlayer?
    var isPause = false
    var videoNumber: Int = 0
    @IBOutlet weak var sound: UIButton!
    var isMute = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("video number \(videoNumber)")
        playVideo()
    }
    
    
    @IBAction func playPause(_ sender: Any) {
        if !isPause{
            pausePlayButton.setTitle("Play", for :.normal)
            isPause = true
            playerVideo?.pause()
        } else {
            pausePlayButton.setTitle("Pause", for:.normal)
            isPause = false
            playerVideo?.play()
        }
    }
            
    func playVideo(){
        guard let videoLocation = Bundle.main.path(forResource: "vid\(videoNumber)", ofType: "mp4") else {
            return
        }
        
        playerVideo = AVPlayer(url: URL(fileURLWithPath: videoLocation))
        let videoView = AVPlayerLayer(player: playerVideo)
        
 
        let videoWidth: CGFloat = 1400
        let videoHeight: CGFloat = 650
        let xPosition: CGFloat = (view.bounds.width - videoWidth) / 2
        let yPosition: CGFloat = (view.bounds.height - videoHeight) / 2
        videoView.frame = CGRect(x: xPosition, y: yPosition, width: videoWidth, height: videoHeight)
        
        videoView.videoGravity = .resizeAspect
        
        view.layer.addSublayer(videoView)
        playerVideo?.play()
    }
    
    @IBAction func onOffSound(_ sender: Any) {
        if !isMute {
            if let image = UIImage(systemName: "speaker.slash.circle")?.resized(to: CGSize(width: 47, height: 47)) {
                let tintedImage = image.withTintColor(UIColor(hex: "#4BA1D2"), renderingMode: .alwaysOriginal)
                sound.setImage(tintedImage, for: .normal)
            }
            isMute = true
            appDelegate.music?.stop()
        } else {
            if let image = UIImage(systemName: "speaker.circle")?.resized(to: CGSize(width: 47, height: 47)) {
                let tintedImage = image.withTintColor(UIColor(hex: "#4BA1D2"), renderingMode: .alwaysOriginal)
                sound.setImage(tintedImage, for: .normal)
            }
            isMute = false
            appDelegate.music?.play()
        }
    }
    
    @IBAction func backToHouse(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
