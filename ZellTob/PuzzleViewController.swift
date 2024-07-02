import UIKit
import SpriteKit

class PuzzleViewController: UIViewController {
    
    var playButton: UIButton!
    var gifImageView: UIImageView?
    var skView: SKView!
    @IBOutlet weak var redirectPage: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create play button
        playButton = UIButton(type: .system)
        playButton.setTitle("Play GIF", for: .normal)
        playButton.addTarget(self, action: #selector(playGif), for: .touchUpInside)
        playButton.frame = CGRect(x: view.frame.midX - 50, y: view.frame.midY - 25, width: 100, height: 50)
        view.addSubview(playButton)
        
        // Initially hide redirectPage button
        redirectPage.isHidden = true
    }
    
    @objc func playGif() {
        guard let gifImage = UIImage.gif(name: "Congrats") else {
            print("GIF file not found")
            return
        }
        
        gifImageView = UIImageView(image: gifImage)
        gifImageView?.frame = view.bounds
        gifImageView?.contentMode = .scaleAspectFit
        gifImageView?.alpha = 0 // Start with the image view invisible
        
        view.addSubview(gifImageView!)
        
        // Extreme transition animation
        gifImageView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1).rotated(by: CGFloat.pi)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2.0, options: .curveEaseInOut, animations: {
            self.gifImageView?.alpha = 1
            self.gifImageView?.transform = .identity
        }, completion: { _ in
            self.showRedirectButton()
        })
        
        // Hide play button
        playButton.isHidden = true
    }
    
    func showRedirectButton() {
        redirectPage.isHidden = false
        redirectPage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1).rotated(by: CGFloat.pi)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2.0, options: .curveEaseInOut, animations: {
            self.redirectPage.alpha = 1
            self.redirectPage.transform = .identity
        }, completion: nil)
    }
    
    @IBAction func pageTO(_ sender: Any) {
        // Implement redirection logic here
    }
}
