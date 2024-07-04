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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
}
