import UIKit
import SpriteKit

class PuzzleSceneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Buat sebuah SKView
        let skView = SKView(frame: view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(skView)

        // Buat sebuah instance dari PuzzleScene
        let puzzleScene = PuzzleScene(size: skView.bounds.size)
        puzzleScene.scaleMode = .aspectFill

        // Presentasikan scene
        skView.presentScene(puzzleScene)
    }
}
